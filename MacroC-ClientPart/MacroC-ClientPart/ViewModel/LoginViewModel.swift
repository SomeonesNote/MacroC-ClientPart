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

class LoginViewModel: ObservableObject {
    @Published var nonce = ""
    @AppStorage("log_status") var log_Status = false
    var firebaseToken : String = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential){
        // getting token ...
        
        let userIdentifier = credential.user
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userIdentifier)
            print("'\(userIdentifier)' is saved on keychain")
        } catch {
            print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
        }
        
        guard let token = credential.identityToken else {
            print("Error with Firebase and getting token")
            return
        }
        
        // Token String ...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with creating token string")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: tokenString,
                                                          rawNonce: nonce)
        
        //MARK: - 파이어베이스에서 던져주는 UID 가져오기
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            if let fuid = result?.user.uid {
                print("LoginViewModel.authenticate.fuid : \(fuid)")
                do {
                    try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "fuid").saveItem(fuid)
                    print("LoginViewModel.authenticate : '\(fuid)' is saved on keychain")
                    AwsService().isSignIn = true
                    UserDefaults.standard.set(true ,forKey: "isSignIn")
                } catch {
                    print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
                }
            }
            
            //MARK: - 파이어베이스에서 토큰을 가져오기
            Auth.auth().currentUser?.getIDToken(completion: { token, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let token = token {
                    print("token: \(token)")// Firebase token
                    self.firebaseToken = token
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "firebaseToken").saveItem(self.firebaseToken)
                        print("LoginViewModel.authenticate.firebaseToken : '\(self.firebaseToken)' is saved on keychain")
                        AwsService().checkSignUp()
                    } catch {
                        print("LoginViewModel.authenticate.error : Unable to save uid to keychain.")
                    }
                }
            })
            
            func verify() {
                let token = self.firebaseToken
            }
            
            print("Logged in Successfully")
            print("tokenString: \(tokenString)")
            //directing to home page
            withAnimation(.easeInOut){
                self.log_Status = true
            }
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
