////
////  LoginView.swift
////  MacroC-ClientPart
////
////  Created by Kimdohyun on 2023/10/05.
////
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseOAuthUI
import AuthenticationServices

struct LoginView: View {
    @State private var isLoggedin: Bool = false
    @State private var userEmail: String = ""
    @State private var showLoginUI: Bool = false
    
    @StateObject var loginData = LoginViewModel()

    var body: some View {
        VStack {
            Text(isLoggedin ? "Logged in: \(userEmail)" : "Not Logged in")
            Button(action: handleLoginLogout) {
                Text(isLoggedin ? "Log Out" : "Log In")
            }
            SignInWithAppleButton{ (request) in
                //requesting parameters from apple login
                loginData.nonce = randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = sha256(loginData.nonce)
               
            } onCompletion: { (result) in
//                getting error or success
                switch result {
                case .success(let user):
                    print("success")
                    guard let credential = user.credential as?  ASAuthorizationAppleIDCredential else {
                        print("Error with Firebase")
                        return
                    }
                    loginData.authenticate(credential: credential)
                    print(String(describing: credential.authorizationCode))
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
        .onAppear(perform: checkLoginStatus)
    }

    func handleLoginLogout() {
        if isLoggedin {
            do {
                try Auth.auth().signOut()
                isLoggedin = false
                userEmail = ""
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
                self.userEmail = user.email ?? "No Email"
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
            // Handle the error
            return UINavigationController() // Return a dummy navigation controller instead
        }

        // Only setting up Apple ID provider
        let providers: [FUIAuthProvider] = [
            FUIOAuth.appleAuthProvider()
        ]
        authUI.providers = providers

        // Customize the UI
        let authViewController = authUI.authViewController()
        return authViewController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Nothing to update
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
