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
}
