//
// LoginViewModel.swift
// MacroC-ClientPart
//
// Created by Kimjaekyeong on 2023/10/05.
//
import Alamofire
import PhotosUI
import SwiftUI

class SignUpViewModel: ObservableObject {
    
    var awsService: AwsService
       
       init(awsService: AwsService) {
           self.awsService = awsService
       }
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isSignednUp: Bool = false
    @Published var isSingedIn: Bool = false
//    @Published var accessToken: String? = KeychainItem.currentUserIdentifier
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var popImagePicker: Bool = false
    @Published var croppedImage: UIImage?
    @Published var usernameStatus: UsernameStatus = .empty // 중복확인
    
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    func signUp() {
        let token : String? = KeychainItem.currentFirebaseToken
        let headers: HTTPHeaders = [.authorization(bearerToken: token ?? "")]
        
        let parameters: [String: String] = [
            "username": username,
            "uid": KeychainItem.currentFuid
        ]
        
        let _ = print(parameters)
        if !username.isEmpty {
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

            }, to: "http://localhost:3000/auth/signup-with-image", method: .post, headers: headers)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let token):
                    print("Success")
                    print(token.accessToken)
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(token.accessToken)
                    } catch {
                        print("tokenResponse on Keychain is fail")
                    }
                    print(AwsService().isSignUp)
                    self.awsService.isSignUp = true
                    print(AwsService().isSignUp)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.isSignednUp = false
                }
            }
        }
    }
}








