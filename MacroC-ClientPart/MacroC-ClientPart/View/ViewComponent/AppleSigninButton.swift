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
                        let UserIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email
                        let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        do {
                            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(UserIdentifier)
                            print("'\(UserIdentifier)' is saved on keychain")
                            userAuth.showLoginView = false
                        } catch {
                            print("AppleSigninButton.error : Unable to save userIdentifier to keychain.")
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("AppleSigninButton.error : \(error.localizedDescription)")
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
