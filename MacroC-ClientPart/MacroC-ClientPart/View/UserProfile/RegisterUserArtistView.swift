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
    @StateObject var viewModel = RegisterUserArtistViewModel()
    
    //MARK: - 2.BODY
    var body: some View {
        ZStack {
                VStack(spacing: UIScreen.getWidth(5)) {
                    imagePickerView
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
                }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .background(backgroundView())
        .hideKeyboardWhenTappedAround()
        .keyboardResponsive()
        .ignoresSafeArea()
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .onChange(of: viewModel.selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.selectedPhotoData = data
                }
            }
        }
        .onChange(of: viewModel.selectedPhotoData) { newValue in
            if let data = newValue, let uiImage = UIImage(data: data) {
                viewModel.copppedImageData = data
                viewModel.croppedImage = uiImage
                viewModel.popImagePicker = false
            }
        }
    }
}
//MARK: - 3 .EXTENSION
extension RegisterUserArtistView {
    
    var imagePickerView: some View {
        Image(uiImage: viewModel.croppedImage ?? UIImage(named: "UserBlank")!)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay(alignment: .bottom) {
                Button{
                    viewModel.popImagePicker = true
                } label: {
                    //TODO: 사진첩 접근해서 사진 받는 거 구현
                    Image(systemName: "camera.circle.fill")
                        .font(.custom40bold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
            .overlay(alignment: .topLeading) {
                Button {
                    viewModel.copppedImageData = nil
                    viewModel.croppedImage = nil
                    viewModel.popImagePicker = false
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.custom20bold())
                        .padding(.init(top: UIScreen.getWidth(45), leading: UIScreen.getWidth(25), bottom: 0, trailing: 0))
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    viewModel.isLoading = true
                    awsService.artistCropedImage = viewModel.croppedImage
                    awsService.user.artist?.stageName = viewModel.artistName
                    awsService.user.artist?.genres = viewModel.genres
                    awsService.user.artist?.artistInfo = viewModel.artistInfo
                    awsService.user.artist?.youtubeURL = viewModel.youtubeURL
                    awsService.user.artist?.instagramURL = viewModel.instagramURL
                    awsService.user.artist?.soundcloudURL = viewModel.soundcloudURL
                    
                    awsService.postUserArtist {
                        viewModel.isLoading = false
                        awsService.getUserProfile {
                            dismiss()
                        }
                    }
                } label: {
                    toolbarButtonLabel(buttonLabel: "Register")
                        .padding(.init(top: UIScreen.getWidth(45), leading: 0, bottom: 0, trailing:  UIScreen.getWidth(25)))
                }
                
            }
    }
    
    var nameTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            Text("Nickname") .font(.custom12semibold()).padding(.leading, UIScreen.getWidth(4))
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("닉네임을 입력하세요", text: $viewModel.artistName)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(10))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var infoTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            Text("Your Info") .font(.custom12semibold()).padding(.leading, UIScreen.getWidth(4))
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Information을 입력하세요", text: $viewModel.artistInfo)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(10))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var youtubeTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name: YouTubeLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("Youtube") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Youtube 계정을 입력하세요", text: $viewModel.youtubeURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(10))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var instagramTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name:InstagramLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("Instagram") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Instagram 계정을 입력하세요", text: $viewModel.instagramURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(10))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var soundcloudTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name:SoundCloudLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("SoundCloud") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Sound Cloud 계정을 입력하세요", text: $viewModel.soundcloudURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(10))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
}



