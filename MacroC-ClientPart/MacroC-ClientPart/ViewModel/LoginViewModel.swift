////
////  LoginViewModel.swift
////  MacroC-ClientPart
////
////  Created by Kimjaekyeong on 2023/10/29.
////
//
//import SwiftUI
//import CryptoKit
//import AuthenticationServices
//import Alamofire
//
//struct AppleTokenResponse: Codable {
//    let refreshtoken: String?
//}
//
//class LoginViewModel: ObservableObject {
//    @Published var nonce = ""
//    @Published var refreshToken: String = ""
//    @Published var firebaseToken : String = ""
//    
//    func revokeAppleToken(refreshToken: String, completionHandler: @escaping () -> Void) {
//        let url = "https://macro-app.fly.dev/apple-auth/revoke"
//        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
//        let parameters: [String: String] = ["refresh_token": refreshToken]
//        
//        AF.request(url,
//                   method: .get,
//                   parameters: parameters,
//                   headers: header
//        )
//        .validate()
//        .response { response in
//            switch response.result {
//            case .success :
//                print("appleRevokeSuccess")
//                
//            case .failure(let error) :
//                print("revokeAppleToken.error : \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    //Apple 로그인
//    func authenticate(credential: ASAuthorizationAppleIDCredential, completion: @escaping () -> Void) {
//        // getting token ...
//        
//        let userIdentifier = credential.user
//        do {
//            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userIdentifier)
//            print("1.LogInViewModel.userIdentifier: '\(userIdentifier)' is saved on keychain") // MARK: 1
//            completion()
//        } catch {
//            print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
//            completion()
//            return
//        }
//        guard let token = credential.identityToken else {
//            print("Error with Firebase and getting token")
//            completion()
//            return
//        }
//        
//        let tokenString = String(decoding: token, as: UTF8.self)
//        
//        //리프레시 토큰 받아와서 저장하는 것
//        if let authorizationCode = credential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
//            do {
//                try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "authorizationCode").saveItem(codeString) // 서버에 authorizationCode 던져주고 refreshToken 받아오는 것
//                print("2.LoginViewModel.authorizationCode: \(codeString)")
//            }catch {
//                print("codeString.error : Unable to save uid to keychain.")
//            }
//        }
//    }
//}
