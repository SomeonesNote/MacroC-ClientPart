//
//  SignUpProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/06.
//

import SwiftUI
import PhotosUI

struct SignUpPageView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = LoginViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            imagePicker
            Spacer()
            textFieldList
            signUpbutton
            Spacer()
        }.cropImagePicker(show: $viewModel.popCrop, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
            .padding()
            .background(backgroundView().hideKeyboardWhenTappedAround())
            
    }
}

//MARK: -3.PREVIEW
#Preview {
    SignUpPageView()
}

//MARK: -4.EXTENSION

extension SignUpPageView {
    var imagePicker: some View {
        Button {
            viewModel.popCrop = true
        } label: {
            if viewModel.croppedImage != nil {
                Image(uiImage: viewModel.croppedImage!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 150)
                    .overlay(Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2)
                                .foregroundColor(.white)
                        }
                    })
            } else {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 150)
                    .overlay {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                }
            }
        }
    }
    
    var textFieldList: some View {
        VStack(spacing: 5){
            TextField("Email", text: $viewModel.email)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            TextField("UserName", text: $viewModel.username)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            TextField("Password", text: $viewModel.password)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
    }
    
    var signUpbutton: some View {
        Button {
            viewModel.signUp()
        } label: {
            HStack{
                Spacer()
                Text("Sign Up").fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .background(viewModel.email.isEmpty || viewModel.username.isEmpty || viewModel.password.isEmpty ?  Color.black : Color.blue)
            .cornerRadius(6)
        }.padding(.top, 30)
            .disabled(viewModel.email.isEmpty || viewModel.username.isEmpty || viewModel.password.isEmpty)

    }
}

