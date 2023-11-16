//
// SignUpProfileSettingView.swift
// MacroC-ClientPart
//
// Created by Kimjaekyeong on 2023/10/06.
//
import SwiftUI
import PhotosUI
struct SignUpView: View {
    //MARK: - 1.PROPERTY
    @EnvironmentObject var awsService : AwsService //TODO: 테스트용으로 넣은거임 다시 지워야함
    
    //MARK: - 2.BODY
    var body: some View {
        VStack(spacing: UIScreen.getWidth(6)) {
            Spacer()

            imagePicker
            Spacer()
            nameTextField
            signUpbutton
            Button {
                awsService.isSignIn = false
            } label: {
                Text("Did you have account already?")
                    .font(.custom10semibold()).foregroundStyle(Color.gray)
                    .padding(10)
            }
            .padding(.bottom, UIScreen.getHeight(40))
        }
        .cropImagePicker(show: $awsService.popImagePicker, croppedImage: $awsService.croppedImage, isLoding: $awsService.isLoading)
        .padding()
        .background(backgroundView().hideKeyboardWhenTappedAround())
        .onAppear {
            awsService.croppedImage = nil
            awsService.user.username = ""
        }
    }
}
//MARK: - 3 .EXTENSION
extension SignUpView {
    var imagePicker: some View {
        Button {
            awsService.popImagePicker = true
        } label: {
            if awsService.croppedImage != nil {
                Image(uiImage: awsService.croppedImage!)
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
                            .font(.custom34regular())
                    }
            }
        }
    }
    var nameTextField: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("닉네임을 입력하세요", text: $awsService.user.username)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(13))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                Button {
                    // TODO: 서버에 같은 닉네임이 있는지 확인하는 함수 + 시트로 가능하다고 띄우는 함수
                } label: {
                    Text("중복확인")
                        .font(.custom10semibold())
                        .padding(UIScreen.getWidth(15))
                        .background(Color(appIndigo))
                        .cornerRadius(6)
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }
            HStack {
                switch awsService.usernameStatus {
                case .empty:
                    Text("사용 가능한 닉네임입니다.") // 아무 메시지도 표시하지 않음
                        .font(.custom10bold())
                        .foregroundColor(.clear)
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                case .duplicated:
                    Text("이미 사용 중인 닉네임입니다.")
                        .font(.custom10bold())
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                case .available:
                    Text("사용 가능한 닉네임입니다.")
                        .font(.custom10bold())
                        .foregroundColor(.blue)
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                Spacer()
            }.padding(.leading, UIScreen.getWidth(5))
        }
    }
    var signUpbutton: some View {
        Button {
            awsService.signUp()
        } label: {
            HStack{
                Spacer()
                Text("Sign Up").font(.custom13bold())
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(awsService.user.username.isEmpty ? Color.gray.opacity(0.3) : Color(appIndigo))
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }.disabled(awsService.user.username.isEmpty)
    }
}
