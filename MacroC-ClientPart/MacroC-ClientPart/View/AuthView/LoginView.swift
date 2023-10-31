////
////  LoginView.swift
////  MacroC-ClientPart
////
////  Created by Kimdohyun on 2023/10/05.
////
//
//import SwiftUI
//
//struct LoginView: View {
//
//    //MARK: -1.PROPERTY
//    @StateObject var viewModel = LoginViewModel()
//
//    //MARK: -2.BODY
//    var body: some View {
//
//            VStack(alignment: .center) {
//                Spacer()
//                Spacer()
//                textFieldList
//                signInbutton
//                AppleSigninButton()
//                Spacer()
//            }
//            .padding()
//            .background(backgroundView().hideKeyboardWhenTappedAround())
//    }
//}
//
//
////MARK: -3.PREVIEW
//#Preview {
//    LoginView()
//}
//
////MARK: -4.EXTENSION
//extension LoginView {
//    var textFieldList: some View {
//        VStack(spacing: 5){
//            TextField("Email", text: $viewModel.email)
//                .padding(13)
//                .background(.ultraThinMaterial)
//                .cornerRadius(6)
//
//            TextField("Password", text: $viewModel.password)
//                .padding(13)
//                .background(.ultraThinMaterial)
//                .cornerRadius(6)
//        }
//    }
//
////    var signInbutton: some View {
////        Button {
//////            viewModel.()
////        } label: {
////            HStack{
////                Spacer()
////                Text("Sign In").fontWeight(.semibold)
////                Spacer()
////            }
////            .padding()
////            .background(.ultraThinMaterial)
////            .cornerRadius(6)
////
////        }.padding(.top, 30)
////    }
//    var signInbutton: some View {
//        Button {
////            viewModel.signIn()
//        } label: {
//            HStack{
//                Spacer()
//                Text("Sign In").fontWeight(.semibold)
//                Spacer()
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .background(viewModel.email.isEmpty || viewModel.password.isEmpty ?  Color.black : Color.blue.opacity(0.7))
//            .cornerRadius(6)
//        }.padding(.top, 30)
//            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
//
//    }
//}
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseOAuthUI
import AuthenticationServices

struct LoginView: View {

    
    @EnvironmentObject var awsService : AwsService
    @State private var isLoggedin: Bool = false
    @State private var userUID: String = ""
    @State private var showLoginUI: Bool = false
    
    @StateObject var loginData = LoginViewModel()
    
    

    var body: some View {
        VStack {
            Text(isLoggedin ? "Logged in: \(userUID)" : "Not Logged in")
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
                    let userIdentifier = credential.user
                    do {
                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").saveItem(userIdentifier)
                        awsService.isSignIn = true
                        awsService.SignIn()
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
//            print("isLoggedin")
//            print(isLoggedin)
            checkLoginStatus()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                print(isLoggedin)
//            }
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

//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
