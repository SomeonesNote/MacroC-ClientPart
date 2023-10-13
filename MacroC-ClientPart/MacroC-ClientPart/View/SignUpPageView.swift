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
        VStack(spacing: UIScreen.getWidth(20)) {
            Spacer()
            imagePicker
            Spacer()
            textField
            signUpbutton
                .padding(.bottom, UIScreen.getHeight(40))
        }
        .cropImagePicker(show: $viewModel.popCrop, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
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
                    .frame(width: UIScreen.getHeight(140))
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
                    .frame(width: UIScreen.getHeight(140))
                    .overlay {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
            }
        }
    }
    
    var textField: some View {
        HStack(spacing: UIScreen.getWidth(8)){
            TextField("닉네임을 입력하세요", text: $viewModel.email)
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(13))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Button {
                // TODO: 서버에 같은 닉네임이 있는지 확인하는 함수 + 시트로 가능하다고 띄우는 함수
            } label: {
                Text("중복확인")
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(15))
                    .background(Color(appIndigo))
                    .cornerRadius(6)
            }
        }
    }
    
    var signUpbutton: some View {
        Button {
            viewModel.signUp()
        } label: {
            HStack{
                Spacer()
                Text("Sign Up").font(.custom14semibold())
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .background(viewModel.email.isEmpty || viewModel.username.isEmpty || viewModel.password.isEmpty ?  Color.black : Color.blue)
            .cornerRadius(6)
        }.disabled(viewModel.email.isEmpty || viewModel.username.isEmpty || viewModel.password.isEmpty)
        
    }
}

