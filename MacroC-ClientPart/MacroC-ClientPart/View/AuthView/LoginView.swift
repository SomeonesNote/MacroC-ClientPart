//
//  LoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseOAuthUI
import AuthenticationServices

struct LoginView: View {

    @EnvironmentObject var awsService : AwsService
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoggedin: Bool = false
    @State private var userUID: String = ""
    @State private var showLoginUI: Bool = false
    
    var body: some View {
        VStack {
            Text(isLoggedin ? "Logged in: \(userUID)" : "Not Logged in")
            Button(action: handleLoginLogout) {
                Text(isLoggedin ? "Log Out" : "Log In")
            }
            SignInWithAppleButton{ (request) in
                viewModel.nonce = randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = sha256(viewModel.nonce)
               
            } onCompletion: { (result) in
                switch result {
                case .success(let user):
                    guard let credential = user.credential as?  ASAuthorizationAppleIDCredential else {
                        print("Error with Firebase")
                        return
                    }
                    viewModel.authenticate(credential: credential) {
                        
                        awsService.checkSignUp()
                    }
                    let userIdentifier = credential.user
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userIdentifier)
                        awsService.isSignIn = true
                        UserDefaults.standard.set(true, forKey: "isSignIn")
                    } catch {
                        print("userIdentifier is not saved")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: UIScreen.getHeight(50))
            .clipShape(Capsule())
            .padding(.horizontal, 10)
        }
        .sheet(isPresented: $showLoginUI) {
            FirebaseLoginViewControllerWrapper()
        }
        .onAppear {
            checkLoginStatus()
        }
    }

    func handleLoginLogout() {
        if isLoggedin {
            do {
                try Auth.auth().signOut()
                isLoggedin = false
                userUID = ""
            } catch {
                print(error.localizedDescription)
            }
        } else {
            showLoginUI = true
        }
    }
    func checkLoginStatus() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.isLoggedin = true
            } else {
                self.isLoggedin = false
            }
        }
    }
}

struct FirebaseLoginViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return UINavigationController()
        }

        let providers: [FUIAuthProvider] = [
            FUIOAuth.appleAuthProvider()
        ]
        authUI.providers = providers

        let authViewController = authUI.authViewController()
        return authViewController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}


