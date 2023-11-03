////
////  RegisterUserArtistView.swift
////  MacroC-ClientPart
////
////  Created by Kimdohyun on 2023/10/05.
////
//

import SwiftUI
import PhotosUI
struct RegisterUserArtistView: View {
    //MARK: - 1.PROPERTY
    @EnvironmentObject var awsService : AwsService
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = RegisterUserArtistViewModel()
    //MARK: - 2.BODY
    var body: some View {
        ScrollView {
            VStack(spacing: UIScreen.getWidth(6)) {
                Spacer()
                imagePicker
                Spacer()
                nameTextField
                infoTextField
                Spacer()
                customDivider()
                Spacer()
                youtubeTextField
                instagramTextField
                soundcloudTextField
                Spacer()
                registerButton
            }
        }
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .padding(.horizontal, 6)
        .toolbarBackground(.hidden, for: .navigationBar)
        .background(backgroundView())
        .hideKeyboardWhenTappedAround()
    }
}
//MARK: - 3 .EXTENSION
extension RegisterUserArtistView {
    var imagePicker: some View {
        Button {
            viewModel.popImagePicker = true
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
                            .font(.custom34regular())
                    }
            }
        }
    }
    var nameTextField: some View {
        VStack(alignment: .leading,spacing: 4) {
            Text("Nickname") .font(.custom13semibold())
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("닉네임을 입력하세요", text: $viewModel.artistName)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(12))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }
    }
    
    var infoTextField: some View {
        VStack(alignment: .leading,spacing: 4) {
            Text("Your Info") .font(.custom13semibold())
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Information을 입력하세요", text: $viewModel.artistInfo)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(12))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }
    }
    
    var youtubeTextField: some View {
        VStack(alignment: .leading,spacing: 4) {
            HStack {
                linkButton(name: YouTubeLogo).frame(width: 25)
                Text("Youtube") .font(.custom13semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Youtube 계정을 입력하세요", text: $viewModel.youtubeURL)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(12))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }
    }
    
    var instagramTextField: some View {
        VStack(alignment: .leading,spacing: 4) {
            HStack {
                linkButton(name:InstagramLogo).frame(width: 25)
                Text("Instagram") .font(.custom13semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Instagram 계정을 입력하세요", text: $viewModel.instagramURL)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(12))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }
    }
    
    var soundcloudTextField: some View {
        VStack(alignment: .leading,spacing: 4) {
            HStack {
                linkButton(name:SoundCloudLogo).frame(width: 25)
                Text("SoundCloud") .font(.custom13semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Sound Cloud 계정을 입력하세요", text: $viewModel.soundcloudURL)
                    .font(.custom14semibold())
                    .padding(UIScreen.getWidth(12))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }
    }
    
    var registerButton: some View {
        Button {
            viewModel.postUserArtist {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    awsService.getUserProfile { //유저프로필 가져오기
                        if awsService.user.artist?.stageName != "" {
                            awsService.isCreatUserArtist = true
                            UserDefaults.standard.set(true ,forKey: "isCreatUserArtist")
                        }
                        dismiss()}
                    awsService.getAllArtistList{}
                }
            }
        } label: {
            HStack{
                Spacer()
                Text("Register").font(.custom13bold())
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(viewModel.artistName.isEmpty || viewModel.artistInfo.isEmpty ? Color.gray.opacity(0.3) : Color(appIndigo))
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }.disabled(viewModel.artistName.isEmpty || viewModel.artistInfo.isEmpty)
    }
}



