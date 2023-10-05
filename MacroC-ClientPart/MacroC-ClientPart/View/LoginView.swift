//
//  LoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct LoginView: View {
    //MARK: -1.PROPERTY
    
    //MARK: -2.BODY
    var body: some View {
        
            ZStack {
                loginBackgroundView()
                VStack(alignment: .center) {
                    
                    Spacer()
                    
                    appTitle
                    
                    Spacer()
                    
                    googleLoginButton
                    
                    appleLoginButton
                    
                    kakaoLoginButton
                }
                .padding(.init(top: 10, leading: 10, bottom: 50, trailing: 10))
            }
        }
    }


//MARK: -3.PREVIEW
#Preview {
    LoginView()
}

//MARK: -4.EXTENSION
extension LoginView {
    
    var appTitle: some View {
        Text("appName")
            .font(.system(size: 50,weight: .heavy))
            .shadow(color: Color(appIndigo1).opacity(0.7), radius: 10)
    }
    
    var googleLoginButton: some View {
        Button {
            //TODO: -Google LogIn 구현하기
          
        } label: {
            LogInButton(LogoName: GoogleLogo, ButtonText: "Log In with Google")
                .modifier(dropShadow())
        }
    }
    
    var appleLoginButton: some View {
        Button {
            //TODO: -Apple LogIn 구현하기
          
        } label: {
            LogInButton(LogoName: AppleLogo, ButtonText: "Log In with Apple")
                .modifier(dropShadow())
        }
    }
    
    var kakaoLoginButton: some View {
        Button {
            //TODO: -Kakao LogIn 구현하기
          
        } label: {
            LogInButton(LogoName: KakaoLogo, ButtonText: "Log In with Kakao")
                .modifier(dropShadow())
        }
    }
}
