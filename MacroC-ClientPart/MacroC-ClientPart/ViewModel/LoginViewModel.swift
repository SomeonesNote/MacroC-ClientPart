//
//  LoginViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/29.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import Firebase
import Alamofire

struct AppleTokenResponse: Codable {
    let refreshtoken: String?
    
}

class LoginViewModel: ObservableObject {
    @Published var nonce = ""
    @Published var refreshToken: String = ""
    @Published var firebaseToken : String = ""
    
    func deleteAccount() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("deleteAccount.error : \(error)")
                } else {
                    print("deleteAccount.Success") }
            }
        } else {
            print("deleteAccount.error")
        }
    }
    
    //Apple Token Revoke
    func revokeAppleToken(refreshToken: String, completionHandler: @escaping () -> Void) {
        let url = "https://macro-app.fly.dev/apple-revoke/revokeToken"
        
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: [String: String] = ["refresh_token": refreshToken]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: header
        )
        .validate()
        .response { response in
            switch response.result {
            case .success :
                print("appleRevokeSuccess")
                
            case .failure(let error) :
                print("revokeAppleToken.error : \(error.localizedDescription)")
            }
        }
    }
    
    //Apple 로그인
    func authenticate(credential: ASAuthorizationAppleIDCredential, completion: @escaping () -> Void) {
        // getting token ...
        let userIdentifier = credential.user
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userIdentifier)
            print("1.LogInViewModel.userIdentifier: '\(userIdentifier)' is saved on keychain") // MARK: 1
            completion()
        } catch {
            print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
            completion()
            return
        }
        guard let token = credential.identityToken else {
            print("Error with Firebase and getting token")
            completion()
            return
        }
        
        // Token String ...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with creating token string")
            completion()
            return
        }
        
        //리프레시 토큰 받아와서 저장하는 것
        if let authorizationCode = credential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
            do {
                try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "authorizationCode").saveItem(codeString) // 서버에 authorizationCode 던져주고 refreshToken 받아오는 것
                print("2.LoginViewModel.authorizationCode: \(codeString)")
            }catch {
                print("codeString.error : Unable to save uid to keychain.")
            }
            let parameters: [String: String] = ["code": codeString]
            AF.request("https://macro-app.fly.dev/apple-revoke/refreshToken", method: .get, parameters: parameters)
                .responseString { response in
                    switch response.result {
                    case .success(let refreshToken):
                        print("8.LoginViewModel.refreshToken : \(refreshToken)")
                        do {
                            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "refreshToken").saveItem(refreshToken)
                        } catch {
                            print("refreshToken not found")
                        }
                    case .failure(let error):
                        print("8.LoginViewModel.refreshToken.Error : \(error.localizedDescription)")
                    }
                }
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: tokenString,
                                                          rawNonce: nonce)
        
        
        
        //MARK: - 파이어베이스에서 던져주는 UID 가져오기
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
                completion()
                return
            }
            if let fuid = result?.user.uid {
                do {
                    try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "fuid").saveItem(fuid)
                    print("4.LoginViewModel.fuid : '\(fuid)' is saved on keychain") //MARK: 4
                } catch {
                    print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
                    completion()
                    return
                }
            }
            
            //MARK: - 파이어베이스에서 토큰을 가져오기
            Auth.auth().currentUser?.getIDToken { token, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion()
                    return
                    
                }
                
                if let token = token {
                    self.firebaseToken = token
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "firebaseToken").saveItem(self.firebaseToken)
                        print("5.LoginViewModel.firebaseToken : '\(self.firebaseToken)' is saved on keychain")
                    } catch {
                        print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
                        completion()
                        return
                    }
                }
                completion()
            }
            
            func verify() {
                let token = self.firebaseToken
            }
            
            print("6.Logged in Successfully") // MARK: 5
            //directing to home page
            
        }
       
    }
}

//helpers

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}



func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}
