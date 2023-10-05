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
        
        ZStack {
            //                loginBackgroundView()
            VStack(alignment: .center) {
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Password", text: $viewModel.password)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                Button {
                    //        viewModel.signIn()
                } label: {
                    Text("Log In")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
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
    
    
}
