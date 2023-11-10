//
// AWSservice.swift
// MacroC-ClientPart
//
// Created by Kimdohyun on 10/19/23.
//
import SwiftUI
import Alamofire

struct TokenResponse : Codable {
    let accessToken : String
}

class AwsService : ObservableObject {
    @Published var user : User = User()
    @Published var addBusking : Busking = Busking()
    @Published var targetBusking : Busking = Busking()
    @Published var myBuskingList : [Busking] = []
    @Published var myArtistBuskingList : [Artist] = []
    
    @Published var following : [Artist] = []
    @Published var followingInt : [Int] = []
    @Published var allAtrist : [Artist] = []
    @Published var allBusking : [Artist] = []
    
    @Published var croppedImage: UIImage?
    @Published var popImagePicker : Bool = false
    @Published var patchcroppedImage: UIImage?
    @Published var artistCropedImage: UIImage?
    @Published var artistPatchcroppedImage: UIImage?
    
    @Published var nowBuskingArtist : [Artist] = []
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    @Published var isLoading: Bool = false
    @Published var isCreatUserArtist: Bool = UserDefaults.standard.bool(forKey: "isCreatUserArtist")
    
    @Published var isSignIn : Bool = UserDefaults.standard.bool(forKey: "isSignIn")
    @Published var isSignUp : Bool = UserDefaults.standard.bool(forKey: "isSignup")
    
    let serverURL: String = "https://macro-app.fly.dev"
    
    @Published var reportText: String = ""
    @Published var blockingList : [Artist] = []
    
    @Published var usernameStatus: UsernameStatus = .empty
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    func signUp() {
        let token : String? = KeychainItem.currentFirebaseToken
        let uid : String = KeychainItem.currentFuid
        let headers: HTTPHeaders = [.authorization(bearerToken: token ?? "")]
        
        let parameters: [String: String] = [
            "username": self.user.username,
            "uid": uid
        ]
        if !self.user.username.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "\(serverURL)/auth/signup-with-image", method: .post, headers: headers)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let token):
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(token.accessToken)
                    } catch {
                        print("#tokenResponse on Keychain is fail")
                    }
                    self.getUserProfile {
                        self.getFollowingList {}}
                    self.getAllArtistList{
                        self.getMyBuskingList()
                    }
                    self.isSignUp = true
                    UserDefaults.standard.set(true, forKey: "isSignup")
                case .failure:
                    self.isSignUp = false
                }
            }
        }
    }
    
    func getUserProfile(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("\(serverURL)/auth/profile", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userData) :
                    self.user = userData
                    if userData.email == nil {
                        self.user.email = ""
                    }
                    if userData.artist == nil {
                        self.user.artist = Artist()
                    }
                case .failure(let error) :
                    print("#getUserProfile.error : \(error.localizedDescription)")
                    if error.responseCode == 401 {
                        self.tokenReresponse {
                            
                        }
                    }
                }
                completion()
            }
    }
    
    func checkSignUp() {
        let uid = KeychainItem.currentFuid
        let parameters: [String : String] = [
            "uid" : "\(uid)"
        ]
        AF.request("\(serverURL)/auth/isSignUp", method: .post, parameters: parameters)
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let bool) :
                    if bool == true {
                        self.getUserProfile {
                            self.getFollowingList {}}
                        self.getAllArtistList{}
                        UserDefaults.standard.set(bool, forKey: "isSignup")
                    }
                    self.isSignUp = bool
                case .failure(let error) :
                    print("checkSignUp.error : \(error.localizedDescription)")
                }
            }
    }
    
    func tokenReresponse(completion: @escaping () -> Void)  {
        let token : String? = KeychainItem.currentFirebaseToken
        let headers: HTTPHeaders = [.authorization(bearerToken: token ?? "")]
        let parameters: [String: String] = [
            "uid": KeychainItem.currentFuid
        ]
        AF.request("\(serverURL)/auth/signin", method: .post, parameters: parameters, headers: headers)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let token):
                    do {
                        self.accesseToken = token.accessToken
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(token.accessToken)
                    } catch {
                        print("#tokenResponse on Keychain is fail")
                    }
                    self.getUserProfile {
                        self.getFollowingList {}}
                    self.getMyBuskingList()
                    self.getMyArtistBuskingList()
                    
                case .failure(let error):
                    print("#tokenReresponse.Error: \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func patchUserProfile() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let parameters: [String: String] = [
            "username" : self.user.username,
        ]
        if !user.username.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.patchcroppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "\(serverURL)/auth/\(self.user.id)", method: .patch)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let patchData):
                    self.user = patchData
                    print("#User Profile Update Success!")
                case .failure(let error):
                    print("#patchUserProfile.Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func following(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/user-following/\(userid)/follow/\(artistid)", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        self.getMyArtistBuskingList()
                        self.getMyBuskingList()
                        print("following.success")
                    }
                case .failure(let error) :
                    print("following.error: \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func getFollowingList(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("\(serverURL)/user-following/\(self.user.id)/following", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self, decoder: decoder) { response in
                switch response.result {
                case .success(let followingData) :
                    self.following = followingData
                    self.followingInt = self.following.map {$0.id}
                    self.getMyArtistBuskingList()
                    self.getMyBuskingList()
                case .failure(let error) :
                    print("#getFollowingList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func unFollowing(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/user-following/\(userid)/unfollow/\(artistid)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        print("#unfollow success")
                    }
                case .failure(let error) :
                    print("#unfollowing.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func deleteUser() {
        let userid : Int = self.user.id
        AF.request("\(serverURL)/auth/\(userid)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.isSignIn = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    UserDefaults.standard.set(false, forKey: "isSignup")
                    KeychainItem.deleteFirebaseTokenFromKeychain()
                    KeychainItem.deleteFuidFromKeychain()
                    KeychainItem.deleteUserIdentifierFromKeychain()
                    KeychainItem.deleteTokenResponseFromKeychain()
                    print("#DeleteUser.success!")
                case .failure(let error) :
                    print("Error : \(error.localizedDescription)")
                }
            }
    }
    
    func postUserArtist(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: String] = [
            "stageName" : self.user.artist?.stageName ?? "",
            "genres" : self.user.artist?.genres ?? "",
            "artistInfo" : self.user.artist?.artistInfo ?? "",
            "youtubeURL" : self.user.artist?.youtubeURL ?? "",
            "instagramURL" : self.user.artist?.instagramURL ?? "",
            "soundcloudURL" : self.user.artist?.soundcloudURL ?? ""
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.artistCropedImage?.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
                multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverURL)/artist-POST/create", method: .post, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserProfile {
                    self.getAllArtistList {
                    }
                }
            case .failure(let error):
                print("postUserArtist.error : \(error.localizedDescription)")
            }
        }
        completion()
    }
    
    func getUserArtistProfile(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("\(serverURL)/artist/\(self.user.id)", method: .get)
            .validate()
            .responseDecodable(of: Artist.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userArtistData) :
                    self.user.artist = userArtistData
                    print("getUserArtistProfile")
                case .failure(let error) :
                    print("getUserArtistProfile.error : \(error)")
                }
                completion()
            }
    }
    
    func patchUserArtistProfile(completion: @escaping () -> Void) {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: String] = [
            "stageName" : self.user.artist?.stageName ?? "",
            "genres" : self.user.artist?.genres ?? "",
            "artistInfo" : self.user.artist?.artistInfo ?? "",
            "youtubeURL" : self.user.artist?.youtubeURL ?? "",
            "instagramURL" : self.user.artist?.instagramURL ?? "",
            "soundcloudURL" : self.user.artist?.soundcloudURL ?? ""
        ]
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.artistPatchcroppedImage?.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
                multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverURL)/artist/update/\(artistid)", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                print("#PatchUserArtist.success")
                self.getUserProfile {
                    self.getFollowingList { }
                }
                self.getAllArtistList { }
            case .failure(let error):
                print("#postUserArtist.error : \(error.localizedDescription)")
            }
        }
        completion()
    }
    
    func deleteUserArtist() {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("\(serverURL)/artist/\(artistid)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getUserProfile {
                        self.isCreatUserArtist = false
                        self.getMyArtistBuskingList()
                        self.getMyBuskingList()
                        UserDefaults.standard.set(false ,forKey: "isCreatUserArtist")
                    }
                case .failure(let error) :
                    print("deleteUserArtist.error : \(error)")
                }
            }
    }
    
    func getAllArtistList(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("\(serverURL)/artist/All", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Artist].self,decoder: decoder) { response in
                switch response.result {
                case .success(let allArtistData) :
                    self.allAtrist = allArtistData
                    print("getAllArtistList.allArtistData")
                case .failure(let error) :
                    print("getAllArtistList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func postBusking() {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        
        let artistid : Int = self.user.artist?.id ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let buskingStartTimeString = dateFormatter.string(from: self.addBusking.BuskingStartTime)
        let buskingEndTimeString = dateFormatter.string(from: self.addBusking.BuskingEndTime)
        
        let parameters: [String: Any] = [
            "BuskingStartTime" : buskingStartTimeString,
            "BuskingEndTime" : buskingEndTimeString,
            "BuskingInfo" : self.addBusking.BuskingInfo,
            "longitude" : self.addBusking.longitude,
            "latitude" : self.addBusking.latitude
        ]
        
        AF.request("\(serverURL)/busking/register/\(artistid)", method: .post, parameters: parameters, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getAllArtistList(completion: {
                        self.getMyBuskingList()
                        self.getMyArtistBuskingList()
                        self.getAllArtistBuskingList{}
                        print("#postBusking.success")
                    })
                case .failure(let error) :
                    print("Post Busking fail Error : \(error)")
                }
            }
    }
    
    func getMyBuskingList() {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("\(serverURL)/busking/getAll/\(artistid)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let myBuskingData) :
                    self.myBuskingList = myBuskingData
                    self.getMyArtistBuskingList()
                    print("getMyBuskingList.success")
                case .failure(let error) :
                    print("getMyBuskingList.error : \(error.localizedDescription)")
                }
            }
    }
    
    func getTargetBusking(tarGetBusking: Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("\(serverURL)/busking/\(tarGetBusking)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Busking.self, decoder: decoder) { response in
                switch response.result {
                case .success(let targetBuskingData) :
                    self.targetBusking = targetBuskingData
                    print("getTargetBusking.success")
                case .failure(let error) :
                    print("getTargetBusking.error : \(error.localizedDescription)")
                }
            }
    }
    
    func deleteBusking(buskingId: Int, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("\(serverURL)/busking/\(self.user.artist?.id ?? 0)/\(buskingId)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getMyBuskingList()
                    self.getUserProfile {
                        self.getAllArtistList {
                            self.getFollowingList {
                                self.getMyArtistBuskingList()
                                print("deleteBusking.success")
                            }
                        }
                    }
                case .failure(let error) :
                    print("deleteBusking.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func getMyArtistBuskingList() {
        let followingList = self.following
        let buskingList = followingList.filter { $0.buskings != nil && !$0.buskings!.isEmpty }
        self.myArtistBuskingList = buskingList
        print("getMyArtistBuskingList")
    }
    
    func getAllArtistBuskingList(completion: @escaping () -> Void) {
        let list = self.allAtrist.filter { $0.buskings != nil && !$0.buskings!.isEmpty }
        self.allBusking = list
        print("allBusking")
        completion()
    }
    
    func blockingArtist(artistId : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/blocking/\(self.user.id)/blockArtist/\(artistId)", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case.success:
                    print("Block Success")
                case .failure(let error):
                    print("Blocking fail Error \(error)")
                }
            }
        completion()
    }
    
    func reporting(artistId : Int,completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: Any] = [
            "userId" : self.user.id,
            "artistId" : artistId,
            "reporting" : self.reportText
        ]
        AF.request("\(serverURL)/reporting/send", method: .post, parameters: parameters, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.blockingArtist(artistId: artistId) {}
                    print("Reporting Success")
                case .failure(let error):
                    print("Reporting fail Error : \(error)")
                }
            }
        completion()
    }
    
    func unblockingArtist(artistId : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/blocking/\(self.user.id)/unblockArtist/\(artistId)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("Unblock Artist Success")
                case .failure(let error):
                    print("Unblock Artist fail Error : \(error)")
                }
                completion()
            }
    }
    
    func getBlockArtist(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("\(serverURL)/blocking/\(self.user.id)/blockedArtists", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self, decoder: decoder) { response in
                switch response.result {
                case .success(let reData):
                    self.blockingList = reData
                    print("Get Block Artist Success")
                case .failure(let error):
                    print("Get Block Artist fail Error : \(error)")
                }
            }
        completion()
    }
}
