//
//  SignUpProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/06.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = LoginViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        VStack(spacing: UIScreen.getWidth(6)) {
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
    SignUpView()
}

//MARK: -4.EXTENSION

extension SignUpView {
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
                    .mask(RadialGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), center: .center,startRadius: 0, endRadius: UIScreen.getHeight(70)))
                    .shadow(color: .white.opacity(0.4),radius: UIScreen.getHeight(5))
                    .overlay {
                        Circle()
                            .stroke(lineWidth: UIScreen.getHeight(2))
                            .blur(radius: UIScreen.getHeight(3))
                            .foregroundColor(Color(appIndigo).opacity(0.6))
                            .padding(0)
                    }
            } else {
                Circle()
                    .stroke(lineWidth: UIScreen.getHeight(3))
                    .frame(width: UIScreen.getHeight(140))
                    .overlay {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.white)
                            .font(.custom40regular())
                    }
            }
        }
    }
    
    var textField: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("닉네임을 입력하세요", text: $viewModel.username)
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
            HStack {
                switch viewModel.usernameStatus {
                case .empty:
                    Text("사용 가능한 닉네임입니다.") // 아무 메시지도 표시하지 않음
                        .font(.custom10bold())
                        .foregroundColor(.clear)
                case .duplicated:
                    Text("이미 사용 중인 닉네임입니다.")
                        .font(.custom10bold())
                        .foregroundColor(.red)
                case .available:
                    Text("사용 가능한 닉네임입니다.")
                        .font(.custom10bold())
                        .foregroundColor(.blue)
                }
                Spacer()
            }.padding(.leading, 5)
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
            .padding(15)
            .background(viewModel.username.isEmpty ?  Color.gray.opacity(0.3) : Color(appIndigo))
            .cornerRadius(6)
        }.disabled(viewModel.username.isEmpty)
        
    }
}

