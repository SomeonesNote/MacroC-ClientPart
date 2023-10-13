//
//  UserBuskerPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

struct UserArtistPageView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: UserArtistPageViewModel
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UIScreen.getWidth(5)) {
                if viewModel.croppedImage != nil { pickedImage }
                else { buskerPageImage }
                buskerPageTitle
                buskerPageFollowButton
                Spacer()
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { firstToolbarItem  }
            ToolbarItem(placement: .topBarTrailing) { secondToolbarItem }
        }
        .cropImagePicker(show: $viewModel.popCrop, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .sheet(isPresented: $viewModel.isEditSocial, onDismiss: {viewModel.isEditSocial = false}) { editSocialSheet }
        .sheet(isPresented: $viewModel.isEditName, onDismiss: {viewModel.isEditName = false}) { editNameSheet }
        .sheet(isPresented: $viewModel.isEditInfo, onDismiss: {viewModel.isEditInfo = false}) { editInfoSheet }
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
        .navigationTitle("")
    }
}



//MARK: -3.PREVIEW
#Preview {
    NavigationView {
        UserArtistPageView(viewModel: UserArtistPageViewModel(userArtist: dummyArtist2))
    }
}

//MARK: -4.EXTENSION
extension UserArtistPageView {
    var buskerPageImage: some View {
        Image(viewModel.userArtist.artistimage)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: UIScreen.getWidth(10)){
                    Button { } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                    
                    Button {viewModel.isEditSocial = true} label: {
                        if viewModel.isEditMode == true {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                        } else { }
                    }
                }
                    .frame(height: UIScreen.getHeight(25))
                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
                ,alignment: .bottomTrailing )
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    Button{
                        viewModel.popCrop = true
                    } label: {
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        Image(systemName: "camera.circle.fill")
                            .font(.custom48bold())
                            .modifier(dropShadow())
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
                HStack(spacing: UIScreen.getWidth(10)){
                    Button { } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                }
                    .frame(height: UIScreen.getHeight(25))
                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
                ,alignment: .bottomTrailing )
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    PhotosPicker(
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.circle.fill")
                                .font(.custom48bold())
                                .modifier(dropShadow())
                    }
                }
            }
        }
    
    var buskerPageTitle: some View {
        return VStack{
            ZStack {
                Text(viewModel.userArtist.stagename)
                    .font(.custom44black())
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button { viewModel.isEditName = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .padding(.horizontal)
                        }
                    }
                }
            }
            ZStack {
                Text(viewModel.EditUserInfo)
                    .font(.custom14heavy())
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button { viewModel.isEditInfo = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }.padding(.bottom, UIScreen.getHeight(20))
        
    }
    
    var buskerPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.custom24black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
        }
    }
    
    var firstToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button {
                viewModel.isEditMode = false
                // 선택한 사진들 취소하는 함수들
                viewModel.selectedItem = nil
                viewModel.selectedPhotoData = nil
                viewModel.croppedImage = nil
            } label: {
                toolbarButtonLabel(buttonLabel: "Cancle")
            })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var secondToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button{
                viewModel.isEditMode = false
                //TODO: 세이브하는 거 구현
            } label: {
                toolbarButtonLabel(buttonLabel: "Save")
            })
        } else {
            return AnyView(Button{
                viewModel.isEditMode = true
            } label: {
                toolbarButtonLabel(buttonLabel: "Edit")
            })
        }
    }
    
    var editSocialSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(YouTubeLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("Youtube")
                    .font(.custom14semibold())
            }
            TextField("", text: $viewModel.userArtist.youtube)
                .font(.custom12semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            HStack {
                Image(InstagramLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("Instagram")
                    .font(.custom14semibold())
            }
            TextField("", text: $viewModel.userArtist.instagram)
                .font(.custom12semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            HStack {
                Image(SoundCloudLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("SoundCloud")
                    .font(.custom14semibold())
            }
            TextField("", text: $viewModel.userArtist.soundcloud)
                .font(.custom12semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(300))])
        .presentationDragIndicator(.visible)
    }
    
    var editNameSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("User Name").font(.custom14semibold())
            }
            TextField("", text: $viewModel.EditUsername)
                .font(.custom12semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
    
    var editInfoSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("User Info").font(.custom14semibold())
            }
            TextField("", text: $viewModel.EditUserInfo)
                .font(.custom12semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
}
