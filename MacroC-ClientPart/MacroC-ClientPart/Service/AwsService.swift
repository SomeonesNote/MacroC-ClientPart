//
//  AWSservice.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 10/19/23.
//

import SwiftUI
import Alamofire

struct TokenResponse : Codable {
    let accessToken : String
}

class AwsService : ObservableObject {
    
    @Published var user : User = User()
//    @Published var userArtist : Artist = Artist()
    @Published var addBusking : Busking = Busking()
    @Published var targetBusking : Busking = Busking()
    @Published var myBuskingList : [Busking] = []
    @Published var following : [Artist] = [] // 유저가 팔로우한 리스트
    @Published var followingInt: [Int] = []
    @Published var allAtrist : [Artist] = [] // 모든 아티스트 리스트
    @Published var croppedImage: UIImage?                       //이거 아티스트이미지랑 유저이미지 분리할 필요가 없는지????
    @Published var nowBuskingArtist : [Artist] = [] // 맵뷰 그리기 위해서 필요한 리스트
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    @Published var popImagePicker: Bool = false
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
                    print("1.userdata : \(userData)")
                    print("2.user : \(self.user)")
                case .failure(let error) :
                    print("Error : \(error)")
                }
                completion()
            }
    }
    
    
    //Add UserProfile
    func postUserProfile(completion: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let parameters: [String: String] = [
            "email" : self.user.email,
            "username" : self.user.username,
            "password" : self.user.password ]
        
        if !user.email.isEmpty && !user.username.isEmpty && !user.password.isEmpty {
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
            }, to: "http://localhost:3000/auth/signup-with-image", method: .post)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success:
                    print("Signed up successfully!")
                    self.user = User()
                    //                    self.isPostProfile = true
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                    //                    self.isPostProfile = false
                }
                completion()
            }
        }
    }
    
    //Login for get Token //배치완료
    func testSignIn() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let parameters: [String : String] = [
            "email": self.user.email,
            "password": self.user.password ]
        
        AF.request("http://localhost:3000/auth/signin", method: .post, parameters: parameters)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    self.accesseToken = tokenResponse.accessToken
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(tokenResponse.accessToken) //키체인에 토큰 등록
                    } catch {
                        print("Error saving token to keychain: \(error)")
                    }
                    self.isSignIn = true
                    UserDefaults.standard.set(true ,forKey: "isSignIn")
                    debugPrint(response)
                    print("Signed In Success")
                    print("UserDefaults.standard.bool(forKey: isSignIn) : \(UserDefaults.standard.bool(forKey: "isSignIn"))")
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
        
        if !user.email.isEmpty && !user.username.isEmpty && !user.password.isEmpty {
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
            }, to: "http://localhost:3000/auth/\(self.user.id)", method: .patch)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let patchData):
                    self.user = patchData
                    print("Patched successfully!")
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
                    print("Followed")
                }
                case .failure :
                    print("Error")
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
                    debugPrint(response)
                    print("followingData : \(self.following)")
                    print("followingInt : \(self.followingInt)")
                case .failure(let error) :
                    print("Error \(error)")
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
                        print("Unfollowed")
                    }
                case .failure :
                    print("Error")
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
                    print("Delete Success!")
                case .failure(let Error) :
                    print("Error : \(Error)")
            }
        }
    }
    
    //Add User Artist ////
    func postUserArtist(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: String] = [
            "stageName" : self.user.artist?.stageName ?? "",
            "genres" : self.user.artist?.genres ?? "",
            "artistInfo" : self.user.artist?.artistInfo ?? ""
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
            }, to: "http://localhost:3000/artist-POST/create", method: .post, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.isCreatUserArtist = true
                    UserDefaults.standard.set(true ,forKey: "isCreatUserArtist")
                    print("Create UserArtist successfully!")
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
            completion()
        }
    }
    
    //Get UserArtistProfilfe // 일단 지금 안쓸듯
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
                    debugPrint(response)
                    print("userArtistdata : \(userArtistData)")
                case .failure(let error) :
                    print("Error : \(error)")
                }
                completion()
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
                    debugPrint(response)
                    print("allArtistData : \(allArtistData)")
                case .failure(let error) :
                    print("Error : \(error)")
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
                    print("Busking Registing Complite")
                case .failure(let error) :
                    print("Error : \(error)")
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
                    print("MyBuskingList : \(myBuskingData)")
                case .failure(let error) :
                    print("Error : \(error)")
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
                    print("Target Busking Info : \(targetBuskingData)")
                case .failure(let error) :
                    print("Error : \(error)")
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
                    print("Delete Success!")
                case .failure(let error) :
                    print("Error : \(error)")
            }
        }
    }
}
