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
    
    @Published var following : [Artist] = [] // 유저가 팔로우한 리스트
    @Published var followingInt : [Int] = []
    @Published var allAtrist : [Artist] = [] // 모든 아티스트 리스트
    @Published var allBusking : [Artist] = []
    
    @Published var croppedImage: UIImage?
    @Published var popImagePicker : Bool = false
    @Published var patchcroppedImage: UIImage?
    @Published var artistCropedImage: UIImage?
    @Published var artistPatchcroppedImage: UIImage?
    
    @Published var nowBuskingArtist : [Artist] = [] // 맵뷰 그리기 위해서 필요한 리스트
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    @Published var isLoading: Bool = false
    
    @Published var isSignIn : Bool = UserDefaults.standard.bool(forKey: "isSignIn") // 테스트 SignIn 테스트 유저 토큰 발행용
    @Published var isSignUp : Bool = UserDefaults.standard.bool(forKey: "isSignup") // 서버에서 받아온 커런트 토큰이 없으면 true 있으면 false
    
    let serverURL: String = "https://macro-app.fly.dev"
    
    @Published var reportText: String = ""
    @Published var blockingList : [Artist] = [] // 유저가 차단한 리스트
    
    @Published var email : String = KeychainItem.currentEmail
    
    @Published var usernameStatus: UsernameStatus = .empty
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    func signUp() {
        let email : String = KeychainItem.currentEmail
        let uid : String = KeychainItem.currentUserIdentifier
        let parameters: [String: String] = [
            "username": self.user.username,
            "uid": uid,
            "email": email
        ]
         if !self.user.username.isEmpty {
             AF.upload(multipartFormData: { multipartFormData in
                 if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
//                     if let imageData = self.croppedImage?.pngData() {
                     multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                 }
                 else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
//                 else if let defaultImageData = UIImage(named: "UserBlank")?.pngData() {
                     multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                 }
                 for (key, value) in parameters {
                     multipartFormData.append(value.data(using: .utf8)!, withName: key)
                 }
             }, to: "\(serverURL)/auth/signup-with-image", method: .post)
             .responseDecodable(of: TokenResponse.self) { response in
                 switch response.result {
                 case .success(let token):
                    print("7.awsService.signUp.Success")
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(token.accessToken)
                    } catch {
                        print("#tokenResponse on Keychain is fail")
                    }
                        self.getUserProfile { //유저프로필 가져오기
                            self.getFollowingList {}}//팔로우 리스트 가져오기
                        self.getAllArtistList{
                            self.getMyBuskingList()
                        }
                    self.isSignUp = true
                    UserDefaults.standard.set(true, forKey: "isSignup")
                case .failure(let error):
                    print("#awsService.isSignUp.Error: \(error.localizedDescription)")
                    self.isSignUp = false
                }
            }
        }
    }
    
    
    //Get Profile //배치완료
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
                    debugPrint(error)
                }
                completion()
            }
    }
    
    //Login for get Token //배치완료
    func checkSignUp(uid: String, completion: @escaping () -> Void) {
        let parameters: [String : String] = [
            "uid" : "\(uid)"
        ]
        AF.request("\(serverURL)/auth/isSignUp", method: .post, parameters: parameters)
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let bool) :
                    if bool == true {
                        self.isSignUp = bool
                        completion()
                        }
                case .failure(let error) :
                    print("7.checkSignUp.error : \(error.localizedDescription)")
                    completion()
                }
            }
        completion()
        }
    
    func tokenReresponse(completion: @escaping () -> Void)  {//TODO: 서버에서 어떻게 되는지 찾기
        let token : String? = ""
        let headers: HTTPHeaders = [.authorization(bearerToken: token ?? "")]
        let parameters: [String: String] = [
            "uid": KeychainItem.currentUserIdentifier
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
                        self.getUserProfile { //유저프로필 가져오기
                            self.getFollowingList {}}//팔로우 리스트 가져오기
                            self.getMyBuskingList()
                            self.getMyArtistBuskingList()
                    
                case .failure(let error):
                    print("#tokenReresponse.Error: \(error.localizedDescription)")
                }
                completion()
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
//                if let imageData = self.patchcroppedImage?.pngData() {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
//                else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
////                else if let defaultImageData = UIImage(named: "UserBlank")?.pngData() {
//                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
//                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "\(serverURL)/auth/\(self.user.id)", method: .patch)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let patchData):
                    self.user = patchData
                    feedback.notificationOccurred(.success)
                    print("#User Profile Update Success!")
                case .failure(let error):
                    print("#patchUserProfile.Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    //Follow //배치완료
    func following(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/user-following/\(userid)/follow/\(artistid)", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        self.getMyArtistBuskingList()
                        self.getMyBuskingList()
                        feedback.notificationOccurred(.success)
                    }
                case .failure(let error) :
                    print("#following.error: \(error.localizedDescription)")
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
    
    //UnFollow //배치완료
    func unFollowing(userid: Int, artistid : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/user-following/\(userid)/unfollow/\(artistid)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getFollowingList {
                        feedback.notificationOccurred(.success)
                    }
                case .failure(let error) :
                    print("#unfollowing.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Delete User Acount //배치완료
    func deleteUser() {
        let reToken : String = KeychainItem.currentAppleRefreashToken
        let parameters : [String : String] = [
            "refresh_token" : reToken
        ]
//        let userid : Int = self.user.id
//        print("\(serverURL)/auth/\(self.user.id)")
        AF.request("\(serverURL)/auth/\(self.user.id)", method: .delete, parameters: parameters)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.isSignIn = false
                    // 서버랑 클라이언트에서 지우는 코드들
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    UserDefaults.standard.set(false, forKey: "isSignup")
                    KeychainItem.deleteUserIdentifierFromKeychain()
                    KeychainItem.deleteTokenResponseFromKeychain()
                    KeychainItem.deleteAppleRefreashToken()
                    feedback.notificationOccurred(.success)
                    
                case .failure(let error) :
                    print("deleteUser.error : \(error.localizedDescription)")
                    debugPrint(error)
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
        
                AF.upload(multipartFormData: { multipartFormData in
                    if let imageData = self.artistCropedImage?.jpegData(compressionQuality: 1) {
//                    if let imageData = self.artistCropedImage?.pngData() {
                        multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                    }
                    else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
//                    else if let defaultImageData = UIImage(named: "UserBlank")?.pngData() {
                        multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                    }
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    }
                }, to: "https://macro-app.fly.dev/artist-POST/create", method: .post, headers: headers)
                .response { response in
                    switch response.result {
                    case .success:
                        self.getUserProfile {
                            self.getAllArtistList {
                                feedback.notificationOccurred(.success)
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
                completion()
        }
    
    //Get User Artist Profilfe //
//    func getUserArtistProfile(completion: @escaping () -> Void) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//        AF.request("\(serverURL)/artist/\(self.user.id)", method: .get)
//            .validate()
//            .responseDecodable(of: Artist.self, decoder: decoder) { response in
//                switch response.result {
//                case .success(let userArtistData) :
//                    self.user.artist = userArtistData
//                    print("getUserArtistProfile.userArtistdata : \(userArtistData)")
//                case .failure(let error) :
//                    print("getUserArtistProfile.error : \(error)")
//                }
//                completion()
//            }
//    }
    
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
        
        //        if !user.artist?.stageName.isEmpty || !user.artist?.artistInfo.isEmpty {
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.artistPatchcroppedImage?.jpegData(compressionQuality: 1) {
//            if let imageData = self.artistPatchcroppedImage?.pngData() {
                multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
//            else if let defaultImageData = UIImage(named: "UserBlank")?.pngData() {
                multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverURL)/artist/update/\(artistid)", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserProfile {
                    self.getFollowingList {
                        feedback.notificationOccurred(.success)
                    }
                }
                self.getAllArtistList { }
            case .failure(let error):
                print("#postUserArtist.error : \(error.localizedDescription)")
            }
        }
        completion()
    }
    
    //Delete User Artist
    func deleteUserArtist() {
        let artistid : Int = self.user.artist?.id ?? 0
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("\(serverURL)/artist/\(artistid)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getUserProfile {
                        self.getMyArtistBuskingList()
                        self.getMyBuskingList()
                        feedback.notificationOccurred(.success)
                    }
                case .failure(let error) :
                    print("#deleteUserArtist.error : \(error)")
                }
            }
    }
    
    //Get All Artist List //배치완료
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
                    completion()
                case .failure(let error) :
                    print("#getAllArtistList.error : \(error.localizedDescription)")
                    completion()
                }
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
            "stageName" : self.user.artist?.stageName ?? "",
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
                        feedback.notificationOccurred(.success)
                        print(parameters)
                    })
                case .failure(let error) :
                    print("postBuskingError : \(error) : \(parameters)")
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
        
        AF.request("\(serverURL)/busking/getAll/\(artistid)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let myBuskingData) :
                    self.myBuskingList = myBuskingData
                    self.getMyArtistBuskingList()
                case .failure(let error) :
                    print("#getMyBuskingList.error : \(error.localizedDescription)")
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
        
        AF.request("\(serverURL)/busking/\(tarGetBusking)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Busking.self, decoder: decoder) { response in
                switch response.result {
                case .success(let targetBuskingData) :
                    self.targetBusking = targetBuskingData
                case .failure(let error) :
                    print("#getTargetBusking.error : \(error.localizedDescription)")
                }
            }
    }
    
    //Delete Busking - 리스트 어레이에 인덱스번호를 인자로 받아서 id값을 사용함 - 아직 사용안됨!!
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
                                feedback.notificationOccurred(.success)
                            }
                        }
                    }
                case .failure(let error) :
                    print("#deleteBusking.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    func getMyArtistBuskingList() {
        let followingList = self.following
        let buskingList = followingList.filter { $0.buskings != nil && !$0.buskings!.isEmpty }
        self.myArtistBuskingList = buskingList
    }
    
    func getAllArtistBuskingList(completion: @escaping () -> Void) {
        let list = self.allAtrist.filter { $0.buskings != nil && !$0.buskings!.isEmpty }
        self.allBusking = list.shuffled()
        completion()
    }
    
    //아티스트 차단
    func blockingArtist(artistId : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/blocking/\(self.user.id)/blockArtist/\(artistId)", method: .post)
          .validate()
          .response { response in
            switch response.result {
            case.success:
                self.getAllArtistList {
                    self.getFollowingList {
                        feedback.notificationOccurred(.success)
                    }
                }
            case .failure(let error):
              print("Blocking fail Error \(error)")
            }
          }
        completion()
      }
    
    //신고하기
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
               self.blockingArtist(artistId: artistId) {
                   feedback.notificationOccurred(.success)
               }
           case .failure(let error):
             print("Reporting fail Error : \(error)")
           }
         }
        completion()
     }
    
    //차단해제
    func unblockingArtist(artistId : Int, completion: @escaping () -> Void) {
        AF.request("\(serverURL)/blocking/\(self.user.id)/unblockArtist/\(artistId)", method: .delete)
          .validate()
          .response { response in
            switch response.result {
            case .success:
                feedback.notificationOccurred(.success)
            case .failure(let error):
              print("Unblock Artist fail Error : \(error)")
            }
            completion()
          }
      }
    
    //차단아티스트 리스트 불러오기
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
            case .failure(let error):
              print("Get Block Artist fail Error : \(error)")
            }
          }
          completion()
      }
}
