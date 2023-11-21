//
//  LoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import Alamofire
import AuthenticationServices

struct SignResponse : Codable {
    var token : String
    var retoken : String
}

struct appleRefreashToken : Codable {
    var refreshToken : String
}

struct LoginView: View {
    
    @EnvironmentObject var awsService : AwsService
    @State private var isLoggedin: Bool = false
    @State private var userUID: String = ""
    let serverURL: String = "https://macro-app.fly.dev"
    @State var serverToken: String = ""
    @State var ReToken : String = KeychainItem.currentAppleRefreashToken
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Spacer()
                Image("LogoPin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(80))
                    .shadow(color: Color.black.opacity(0.2) ,radius: UIScreen.getHeight(5))
                Spacer()
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        
                        switch result {
                        case .success(let authResults):
                            isLoggedin = true
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential :
                                let userId = appleIDCredential.user
                                let email = appleIDCredential.email
                                let authCodeData = appleIDCredential.authorizationCode
                                let authCode = String(data: authCodeData ?? Data(), encoding: .utf8)
                                appleLogin(authCode: authCode ?? "")
                                
                                do {
                                    try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userId)
                                    if email != "" {
                                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "email").saveItem(email ?? "")
                                    }
                                } catch {
                                    print(error)
                                }
                            default:
                                break
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: UIScreen.getHeight(50))
                .clipShape(Capsule())
                .padding(.horizontal, 10)
                Spacer()
            }.blur(radius: isLoggedin ? 8 : 0)
            if isLoggedin {
                ProgressView()
            }
        }
        .background(Color.white.ignoresSafeArea())
        .onDisappear {
            isLoggedin = false
        }
    }
}

extension LoginView {
    
    func appleLogin(authCode: String) {
        let uid : String = KeychainItem.currentUserIdentifier
        let parameters : [String : String] = [
            "code" : authCode
        ]
        AF.request("https://macro-app.fly.dev/apple-auth/refreshToken", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: appleRefreashToken.self) { response in
                switch response.result {
                case .success(let reData) :
                    self.ReToken = reData.refreshToken
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "AppleRefreashToken").saveItem(reData.refreshToken)
                    } catch {
                        print("Apple Refreash Token on Keychain is fail")
                    }
                    awsService.checkSignUp() {
                    }
                    awsService.isSignIn = true
                    UserDefaults.standard.set(true, forKey: "isSignIn")
                case .failure(let error) :
                    print("getRefreshToken.error : \(error.localizedDescription)")
                }
            }
    }
}
