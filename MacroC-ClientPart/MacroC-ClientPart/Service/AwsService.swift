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
    @Published var following : [Artist] = [] // 유저가 팔로우한 리스트
    @Published var followingInt: [Int] = []
    @Published var allAtrist : [Artist] = [] // 모든 아티스트 리스트
    @Published var croppedImage: UIImage?
    @Published var patchcroppedImage: UIImage?
    @Published var nowBuskingArtist : [Artist] = [] // 맵뷰 그리기 위해서 필요한 리스트
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    @Published var isLoading: Bool = false
    @Published var isCreatUserArtist: Bool = UserDefaults.standard.bool(forKey: "isCreatUserArtist")
    @Published var isSignIn : Bool = UserDefaults.standard.bool(forKey: "isSignIn") // 테스트 SignIn 테스트 유저 토큰 발행용
    @Published var usernameStatus: UsernameStatus = .empty
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    
    //Get Profile //배치완료
    func getUserProfile(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/auth/profile", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userData) :
                    self.user = userData
                    if userData.artist == nil {
                        self.user.artist = Artist(id: 0, stageName: "", artistInfo: "", genres: "", members: [], buskings: [])
                    }
                    print(self.user)
                    print("Get User Profile Success!")
                case .failure(let error) :
                    print("Error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Login for get Token //배치완료
    func SignIn() {
        let parameters: [String : String] = [
            "email": self.user.email,
            "password": self.user.password
        ]
        AF.request("http://localhost:3000/auth/signin", method: .post, parameters: parameters)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    self.accesseToken = tokenResponse.accessToken
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(tokenResponse.accessToken) //키체인에 토큰 등록
                    } catch {
                        print("testSignIn.Error saving token to keychain: \(error.localizedDescription)")
                    }
                    self.isSignIn = true
                    UserDefaults.standard.set(true ,forKey: "isSignIn")
                    print("SignIn Success!")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    //Edit UserProfile
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
            }, to: "http://localhost:3000/auth/\(self.user.id)", method: .patch)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let patchData):
                    self.user = patchData
                    print("User Profile Update Success!")
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    //Follow //배치완료
    func following(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/user-following/\(userid)/follow/\(artistid)", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        print("following.success")
                    }
                case .failure(let error) :
                    print("following.error: \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Following List //배치완료
    func getFollowingList(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/user-following/\(self.user.id)/following", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self, decoder: decoder) { response in
                switch response.result {
                case .success(let followingData) :
                    self.following = followingData
                    self.followingInt = self.following.map {$0.id}
                    print("getFollowingList.followingData : \(self.following)")
                    print("getFollowingList.followingInt : \(self.followingInt)")
                case .failure(let error) :
                    print("getFollowingList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //UnFollow //배치완료
    func unFollowing(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/user-following/\(userid)/unfollow/\(artistid)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        print("unfollow success")
                    }
                case .failure(let error) :
                    print("unfollowing.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Delete User Acount //배치완료
    func deleteUser() {
        AF.request("http://localhost:3000/auth/\(self.user.id)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.isSignIn = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
                    print("DeleteUser.success!")
                case .failure(let error) :
                    print("Error : \(error.localizedDescription)")
                }
            }
    }
    
    //Add User Artist //
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
        
        if ((user.artist?.stageName.isEmpty) == nil) /*&& ((user.artist?.genres.isEmpty) == nil)*/ && ((user.artist?.artistInfo.isEmpty) == nil) {
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
            }, to: "http://localhost:3000/artist-POST/create", method: .post, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile {
                        self.isCreatUserArtist = true
                        UserDefaults.standard.set(true ,forKey: "isCreatUserArtist")
                    }
                case .failure(let error):
                    print("postUserArtist.error : \(error.localizedDescription)")
                }
            }
            completion()
        }
    }
    
    //Get User Artist Profilfe // 일단 지금 안쓸듯
    func getUserArtistProfile(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/artist/\(self.user.id)", method: .get)
            .validate()
            .responseDecodable(of: Artist.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userArtistData) :
                    self.user.artist = userArtistData
                    print("getUserArtistProfile.userArtistdata : \(userArtistData)")
                case .failure(let error) :
                    print("getUserArtistProfile.error : \(error)")
                }
                completion()
            }
    }
    
    //Patch User Artist
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
        
        if ((user.artist?.stageName.isEmpty) == nil) && ((user.artist?.genres.isEmpty) == nil) && ((user.artist?.artistInfo.isEmpty) == nil) {
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
            }, to: "http://localhost:3000/artist/update/\(artistid)", method: .patch, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                        print("PatchUserArtist.success")
                case .failure(let error):
                    print("postUserArtist.error : \(error.localizedDescription)")
                }
            }
            completion()
        }
    }
    
    //Delete User Artist
    func deleteUserArtist() {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("http://localhost:3000/artist/\(artistid)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getUserProfile {
                        self.isCreatUserArtist = false
                        UserDefaults.standard.set(false ,forKey: "isCreatUserArtist")
                        print("UserDefaults.standard.bool : \( UserDefaults.standard.bool(forKey: "isCreatUserArtist"))")
                    }
                case .failure(let error) :
                    print("deleteUserArtist.error : \(error)")
                }
            }
    }
    
    //Get All Artist List //배치완료
    func getAllArtistList(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/artist/All", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self,decoder: decoder) { response in
                switch response.result {
                case .success(let allArtistData) :
                    self.allAtrist = allArtistData
                    print("getAllArtistList.allArtistData : \(self.allAtrist)")
                case .failure(let error) :
                    print("getAllArtistList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Add Busking
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
            "longitudde" : self.addBusking.longitude,
            "latitude" : self.addBusking.latitude
        ]
        
        AF.request("http://localhost:3000/busking/register/\(artistid)", method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: Busking.self ,decoder: decoder) { response in
                switch response.result {
                case .success :
                    print("postBusking.success")
                case .failure(let error) :
                    print("postBusking.error : \(error.localizedDescription)")
                }
            }
    }
    
    //Get My Busking List //??
    func getMyBuskingList() {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("http://localhost:3000/busking/getAll/\(artistid)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let myBuskingData) :
                    self.myBuskingList = myBuskingData
                    print("getMyBuskingList.success : \(myBuskingData)")
                case .failure(let error) :
                    print("getMyBuskingList.error : \(error.localizedDescription)")
                }
            }
    }
    
    // 버스킹 아이디로 버스킹 가져오기 - 어디서 어떻게 써야할지 모르겠음(테이블이 만들어져있어서 우선 만들어 놓음)
    func getTargetBusking(tarGetBusking: Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("http://localhost:3000/busking/\(tarGetBusking)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Busking.self, decoder: decoder) { response in
                switch response.result {
                case .success(let targetBuskingData) :
                    self.targetBusking = targetBuskingData
                    print("getTargetBusking.success : \(targetBuskingData)")
                case .failure(let error) :
                    print("getTargetBusking.error : \(error.localizedDescription)")
                }
            }
    }
    
    //Delete Busking - 리스트 어레이에 인덱스번호를 인자로 받아서 id값을 사용함 - 아직 사용안됨!!
    func deleteBusking(at index: Int) {
        guard index >= 0 && index < myBuskingList.count else {
            print("Invalid index")
            return }
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("http://localhost:3000/busking/\(self.myBuskingList[index].id)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    print("deleteBusking.success")
                case .failure(let error) :
                    print("deleteBusking.error : \(error.localizedDescription)")
                }
            }
    }
}
