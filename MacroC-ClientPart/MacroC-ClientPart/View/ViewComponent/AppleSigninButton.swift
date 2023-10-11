//
//  AppleSigninButton.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/12.
//
import SwiftUI
import AuthenticationServices

struct LoginTestView: View {
    var body: some View {
        VStack {
            AppleSigninButton()
        }
        .frame(height:UIScreen.main.bounds.height)
        .background(Color.white)
        
    }
    
}

struct AppleSigninButton : View{
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    
                    switch authResults.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let UserIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email
                        let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(height:50)
        .cornerRadius(8)
    }
}

#Preview {
    LoginTestView()
}
