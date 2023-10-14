//
//  LoginViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/05.
//

import Alamofire
import PhotosUI
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isSignednUp: Bool = false
    @Published var isSingedIn: Bool = false
    @Published var accessToken: String? = UserDefaults.standard.string(forKey: "accessToken")
    @Published var user: User?
    @Published var avatarImage: UIImage? // 선택된 이미지를 UIImage로 나타내는데 사용
    @Published var isLoading: Bool = false
    @Published var popCrop: Bool = false
    @Published var croppedImage: UIImage?
    @Published var usernameStatus: UsernameStatus = .empty // 중복확인
    
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    //서버에서 프로필 가져오는 함수
    func getProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: accessToken ?? "")]
        AF.request("http://localhost:3000/auth/profile", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let userData) :
                    self.user = userData
                case .failure(let error) :
                    print("Error : \(error)")
                }
            }
        }
    

    //  func signIn() {
    //    let parameters: Parameters = [
    //      "email": email,
    //      "password": password
    //    ]
    //    AF.request("http://localhost:3000/auth/signin", method: .post, parameters: parameters)
    //          .responseDecodable(of: TokenResponse.self) { response in
    //        switch response.result {
    //        case .success(let tokenResponse):
    //          let token = tokenResponse.accessToken
    //          UserDefaults.standard.set(token, forKey: "accessToken")
    //          self.isSingedIn = true
    //          self.accessToken = token
    //        case .failure(let error):
    //          print("Error: \(error.localizedDescription)")
    //        }
    //      }
    //  }
    
    func signUp() {
        let parameters: [String: String] = [
            "email": email,
            "username": username,
            "password": password,
        ]
        if !email.isEmpty && !username.isEmpty && !password.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.avatarImage?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "defaultImage")?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "http://localhost:3000/auth/signup-with-image", method: .post)
            .response { response in
                switch response.result {
                case .success:
                    print("success")
                    self.initStates()
                    self.isSignednUp = true
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.isSignednUp = false
                }
            }
        }
    }
//    //TODO: 중복확인하는 함수 - 텍스트필드에 온체인지에 넣어야함
//    func checkUsername() {
//        // TODO: 서버에 요청하여 중복 확인
//        if username.isEmpty {
//            usernameStatus = .empty
//        } else if {
//            usernameStatus = .duplicated
//        } else {
//            usernameStatus = .available
//        }
//    }
    
    func initStates() {
        self.email = ""
        self.username = ""
        self.password = ""
        self.avatarImage = nil
    }
}
