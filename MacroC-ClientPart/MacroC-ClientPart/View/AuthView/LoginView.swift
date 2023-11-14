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


struct LoginView: View {
    
    @EnvironmentObject var awsService : AwsService
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoggedin: Bool = false
    @State private var userUID: String = ""
    //    @State private var showLoginUI: Bool = false
    let serverURL: String = "https://macro-app.fly.dev"
    @State var serverToken: String = ""
    @State var refreshToken: String = ""
    
    
    var body: some View {
        VStack {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential :
                            let UID = appleIDCredential.user
                            
                            let email = appleIDCredential.email
                            let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                            do {
                                sendAppleLoginRequest(userID: UID, email: email ?? "", identityToken: AuthorizationCode ?? "")
                                try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(UID)
                                
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
        }
    }
}
//do {
//    try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem()
//    awsService.isSignIn = true
//    UserDefaults.standard.set(true, forKey: "isSignIn")
//    print("3.awsService.isSignIn : \(awsService.isSignIn)")
//} catch {
//    print("userIdentifier is not saved")
//}

extension LoginView {
    func sendAppleLoginRequest(userID: String, email: String, identityToken: String) {
        let _ = print("sendAppleLoginRequest은 여기서 터짐")
//        let parameters: [String: Any] = [
//            "userID" : userID,
//            "email" : email,
//            "identityToken" : identityToken
//        ]
        
        AF.request("\(serverURL)/apple-auth/login", method: .get)
            .validate()
            .response /*Decodable(of: SignResponse.self)*/ { response in
                switch response.result {
                case .success(let reData):
//                    do {
//                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "ServerToken").saveItem(reData.token)
//                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "RefreshToken").saveItem(reData.retoken)
//                    } catch {
//                        print("Token Response on Keychain is fail")
//                    }
                    
//                    serverToken = reData.token
//                    refreshToken = reData.retoken
                    debugPrint(response)
                    print(reData)
                    debugPrint(reData)
                    awsService.getUserProfile{ }
                    awsService.isSignIn = true
                    UserDefaults.standard.set(true, forKey: "isSignIn")
                    print("Apple Login Success")
                case .failure(let error):
                    awsService.isSignIn = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    print("Error : \(error)")
                }
            }
    }
    
    func sendAppleLoginRedirectRequest(userID: String, refreshToken: String) {
        let _ = print("sendAppleLoginRedirectRequest은 여기서 터짐")
        let parameters: [String: Any] = [
            "userID": userID,
            "refreshToken": refreshToken
        ]
        
        AF.request("\(serverURL)/apple-auth/callback", method: .post, parameters: parameters)
            .response { response in
                switch response.result {
                case.success :
                    print(response)
                    
                case.failure(let error) :
                    print(error)
                }
            }
    }
}

//struct FirebaseLoginViewControllerWrapper: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UINavigationController
//
//    func makeUIViewController(context: Context) -> UINavigationController {
//        guard let authUI = FUIAuth.defaultAuthUI() else {
//            // Handle the error
//            return UINavigationController() // Return a dummy navigation controller instead
//        }
//
//        // Only setting up Apple ID provider
//        let providers: [FUIAuthProvider] = [
//            FUIOAuth.appleAuthProvider()
//        ]
//        authUI.providers = providers
//
//        // Customize the UI
//        let authViewController = authUI.authViewController()
//        return authViewController
//    }
//
//    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
//        // Nothing to update
//    }
//}



