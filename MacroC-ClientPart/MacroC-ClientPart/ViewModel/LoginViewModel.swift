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
    @Published var accessToken: String? = KeychainItem.currentUserIdentifier
    @Published var user: User?
    
    @Published var selectedPhotoData: Data?
    @Published var copppedImageData: Data?
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var croppedImage: UIImage?
   
    @Published var isLoading: Bool = false
    @Published var popImagePicker: Bool = false
    @Published var usernameStatus: UsernameStatus = .empty // 중복확인
    
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }

    
    func signUp() {
        let parameters: [String: String] = [
            "email": email,
            "username": username,
            "password": password,
        ]
        if !email.isEmpty && !username.isEmpty && !password.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 0.5) {
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
                    print("Success")
                    self.isSignednUp = true
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.isSignednUp = false
                }
            }
        }
    }
}
