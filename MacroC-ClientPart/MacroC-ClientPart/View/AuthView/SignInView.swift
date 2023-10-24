//
//  SignInView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import SwiftUI

struct SignInView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService : AwsService
    
    //MARK: -2.BODY
    var body: some View {
//        VStack(spacing: UIScreen.getWidth(80)) {
//            Image(AppLogo)
//                .resizable()
//                .scaledToFit()
//                .frame(height: UIScreen.getHeight(200))
//                .cornerRadius(30)
//            AppleSigninButton().padding()
//                .offset(y: UIScreen.getHeight(240))
//                .shadow(color: .black.opacity(0.5) ,radius: UIScreen.getWidth(8))
//        }.background(backgroundView().ignoresSafeArea())
        NavigationView {
            VStack(spacing: UIScreen.getWidth(6)) {
                emailTextField
                passwordTextField
                signInbutton
                addAcountbutton
                
                    .padding(.bottom, UIScreen.getHeight(40))
            }
            .padding()
            .background(backgroundView().hideKeyboardWhenTappedAround())
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    SignInView()
}

//MARK: -4.EXTENSION
extension SignInView {
    var emailTextField: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("이메일주소를 입력하세요", text: $awsService.user.email)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(13))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
            Text(" ").font(.custom14semibold())
        }
    }
    
    var passwordTextField: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("비밀번호를 입력하세요", text: $awsService.user.password)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(13))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
            Text(" ").font(.custom14semibold())
        }
    }
    
    var signInbutton: some View {
        Button {
            awsService.testSignIn()
        } label: {
            HStack{
                Spacer()
                Text("Sign In").font(.custom13bold())
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(awsService.user.username.isEmpty ?  Color.gray.opacity(0.3) : Color(appIndigo))
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }.disabled(awsService.user.email.isEmpty || awsService.user.password.isEmpty)
    }
    
    var addAcountbutton: some View {
        NavigationLink {
            SignUpView()
        } label: {
            HStack{
                Spacer()
                Text("Add Acount").font(.custom13bold())
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(Color.blue)
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }
    }
}
