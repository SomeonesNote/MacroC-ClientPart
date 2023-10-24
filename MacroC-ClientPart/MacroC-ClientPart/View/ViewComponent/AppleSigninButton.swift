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
        }.frame(height:UIScreen.main.bounds.height).background(Color.white)
    }
}

struct AppleSigninButton : View{
    
    @EnvironmentObject var userAuth: AppleAuth
    
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
                        _ =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        _ = appleIDCredential.email
                        _ = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        _ = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        do {
                            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(UserIdentifier)
                            print("'\(UserIdentifier)' is saved on keychain")
                            userAuth.showLoginView = false
                        } catch {
                            print("Unable to save userIdentifier to keychain.")
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(height:UIScreen.getHeight(50))
        .cornerRadius(UIScreen.getHeight(25))
    }
}

#Preview {
    LoginTestView()
}
