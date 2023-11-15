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

struct refreah : Codable {
    var refreash : String
}


struct LoginView: View {
    
    @EnvironmentObject var awsService : AwsService
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoggedin: Bool = false
    @State private var userUID: String = ""
    let serverURL: String = "https://macro-app.fly.dev"
    @State var serverToken: String = ""
    @State var refreshToken: String = ""
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Spacer()
                Image(AppLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(100))
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 30)
//                            .stroke(lineWidth: UIScreen.getWidth(2))
//                            .frame(width: UIScreen.getWidth(180), height: UIScreen.getHeight(180))
//                            .blur(radius: 2)
//                            .foregroundColor(Color.white.opacity(0.1))
//                            .padding(0)
//                    }
                    .shadow(color: Color.white.opacity(0.2) ,radius: UIScreen.getHeight(8))
//                Text("Yonder").font(.custom32black()).shadow(color: Color.white.opacity(0.2) ,radius: UIScreen.getHeight(8))
//                    .padding(.horizontal, 20)
//                    .overlay {
//                        Capsule().stroke(lineWidth: 5)
//                    }
//                    .padding(.top, UIScreen.getHeight(30))
                Spacer()
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                     
                    },
                    onCompletion: { result in
                        isLoggedin = true
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential :
                                let userId = appleIDCredential.user
                                let email = appleIDCredential.email
                                let identityTokenData = appleIDCredential.identityToken
                                let authCodeData = appleIDCredential.authorizationCode
                                let identityToken = String(data: identityTokenData ?? Data(), encoding: .utf8)
                                let authCode = String(data: authCodeData ?? Data(), encoding: .utf8)
                             
                                print("userId : \(userId)")
                                print("email : \(email ?? "")")
                                print("identityToken : \(identityToken ?? "")")
                                print("authcode : \(authCode ?? "")")
                                
                                awsService.email = email ?? ""
                                try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "authorizationCode").saveItem(authCode ?? "")
                                sendToServer(userId: userId, email: email, identityToken: identityToken, authCode: authCode) {
                                    awsService.checkSignUp(uid: userId) {
                                     
                                    }
                                }
                                
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
                .signInWithAppleButtonStyle(.black)
                .frame(height: UIScreen.getHeight(50))
                .clipShape(Capsule())
                .padding(.horizontal, 10)
                Spacer()
            }.blur(radius: isLoggedin ? 8 : 0)
            if isLoggedin {
                ProgressView()
            }
        }
        .background(backgroundView().ignoresSafeArea())
        .onDisappear {
            isLoggedin = false
        }
    }
}

extension LoginView {
    
    func sendToServer(userId: String, email: String?, identityToken: String?, authCode: String?, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let parameters: [String: Any] = [
            "user_id": userId,
            "email": email ?? "",
            "id_token": identityToken ?? "",
            "authCode": authCode ?? ""
        ]
        
        AF.request("https://macro-app.fly.dev/apple-auth/callback", method: .post, parameters: parameters, headers: headers)
            .response { response in
            switch response.result {
            case.success :
                
                print("AppleLogin Success!")
                awsService.isSignIn = true
                UserDefaults.standard.set(true, forKey: "isSignIn")
                debugPrint(response)
                getRefreshToken(authCode: authCode ?? "")
                
            case.failure(let error) :
                print("AppleLogin.error : \(error)")
                awsService.isSignIn = false
                UserDefaults.standard.set(false, forKey: "isSignIn")
            }
        }
        completion()
    }
    
    func getRefreshToken(authCode: String) {
        let url = "https://macro-app.fly.dev/apple-auth/refreshToken"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: [String: String] = ["code": authCode]
        print(parameters)
        
        AF.request(url, method: .get, parameters: parameters, headers: header)
        .validate()
        .responseDecodable(of: refreah.self) { response in
            switch response.result {
            case .success(let reData) :
                print("getRefreshToken.Success")
                print(reData)
            case .failure(let error) :
                print("getRefreshToken.error : \(error.localizedDescription)")
            }
        }
    }
}
