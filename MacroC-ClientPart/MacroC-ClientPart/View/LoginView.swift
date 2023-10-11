//
//  LoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: -1.PROPERTY
    @StateObject var viewModel = LoginViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        
            VStack(alignment: .center) {
                Spacer()
                Spacer()
                textFieldList
                signInbutton
                AppleSigninButton()
                Spacer()
            }
            .padding()
            .background(backgroundView().hideKeyboardWhenTappedAround())
    }
}


//MARK: -3.PREVIEW
#Preview {
    LoginView()
}

//MARK: -4.EXTENSION
extension LoginView {
    var textFieldList: some View {
        VStack(spacing: 5){
            TextField("Email", text: $viewModel.email)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            TextField("Password", text: $viewModel.password)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
    }
    
//    var signInbutton: some View {
//        Button {
////            viewModel.()
//        } label: {
//            HStack{
//                Spacer()
//                Text("Sign In").fontWeight(.semibold)
//                Spacer()
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .cornerRadius(6)
//            
//        }.padding(.top, 30)
//    }
    var signInbutton: some View {
        Button {
//            viewModel.signIn()
        } label: {
            HStack{
                Spacer()
                Text("Sign In").fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .background(viewModel.email.isEmpty || viewModel.password.isEmpty ?  Color.black : Color.blue.opacity(0.7))
            .cornerRadius(6)
        }.padding(.top, 30)
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)

    }
}
