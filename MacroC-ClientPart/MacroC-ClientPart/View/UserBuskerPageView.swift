//
//  UserBuskerPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import PhotosUI

struct UserBuskerPageView: View {
    @ObservedObject var viewModel: UserBuskerPageViewModel
    
    var body: some View {
        ZStack {
            backgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    if viewModel.croppedImage != nil { pickedImage }
                    else { buskerPageImage }
                    buskerPageTitle
                    buskerPageFollowButton
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isEditMode {
                    Button {
                        viewModel.isEditMode = false
                        //TODO: 취소하는 거 구현
                        viewModel.selectedItem = nil
                        viewModel.selectedPhotoData = nil
                        viewModel.croppedImage = nil
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Cancle")
                    }
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isEditMode {
                    Button{
                        viewModel.isEditMode = false
                        //TODO: 세이브하는 거 구현
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Save")
                    }
                } else {
                    Button{
                        viewModel.isEditMode = true
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Edit")
                    }
                }
            } //탑트레일링 툴바아이템
        }
        .onChange(of: viewModel.selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.selectedPhotoData = data
                }
            }
        }
        .onChange(of: viewModel.selectedPhotoData) { newValue in
            if let data = newValue, let uiImage = UIImage(data: data) {
                viewModel.popCropImage = data
                viewModel.croppedImage = uiImage
                viewModel.popCrop = false
            }
        }
        .cropImagePicker(show: $viewModel.popCrop, croppedImage: $viewModel.croppedImage)
    }
}



//MARK: -3.PREVIEW
#Preview {
    NavigationView {
        UserBuskerPageView(viewModel: UserBuskerPageViewModel(userBusker: dummyUserBusker))
    }
}

//MARK: -4.EXTENSION
extension UserBuskerPageView {
    var buskerPageImage: some View {
        Image(viewModel.userBusker.avartaUrl)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: 10){
                    Button { } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                }
                    .frame( height: 27)
                    .padding(.init(top: 0, leading: 0, bottom: 20, trailing: 15))
                ,alignment: .bottomTrailing )
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    Button{
                        viewModel.popCrop = true
                    } label: {
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        Image(systemName: "camera.circle.fill")
                            .font(.largeTitle)
                            .modifier(dropShadow())
                            .scaleEffect(1.5)
                            .opacity(0.9)
                            .padding(.bottom, 60)
                    }
                }
            }
    }
    
    var pickedImage: some View {
        Image(uiImage: viewModel.croppedImage!)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: 10){
                    Button { } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                }
                    .frame( height: 27)
                    .padding(.init(top: 0, leading: 0, bottom: 20, trailing: 15))
                ,alignment: .bottomTrailing )
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    PhotosPicker(
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.circle.fill")
                                .font(.largeTitle)
                                .modifier(dropShadow())
                                .scaleEffect(1.5)
                                .opacity(0.9)
                                .padding(.bottom, 60)
                        }
                }
            }
    }
    
    var buskerPageTitle: some View {
        return VStack{
            Text(viewModel.userBusker.username)
                .font(.largeTitle)
                .fontWeight(.black)
                .scaleEffect(1.4)
            
            Text("Simple Imforamtion of This Artist")
                .font(.headline)
                .fontWeight(.heavy)
                .padding(.bottom, 20)
        }
        
    }
    
    var buskerPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.title2)
                .fontWeight(.black)
                .padding(.init(top: 7, leading: 30, bottom: 7, trailing: 30))
                .background{ Capsule().stroke(Color.white, lineWidth: 2) }
                .modifier(dropShadow())
        }
    }
}
