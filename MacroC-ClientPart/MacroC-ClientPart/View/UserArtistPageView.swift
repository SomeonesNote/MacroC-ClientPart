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

struct UserArtistPageView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: UserArtistPageViewModel
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
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
                HStack(spacing: 10){
                    Button { } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                    
                    Button {viewModel.isEditSocial = true} label: {
                        if viewModel.isEditMode == true {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                        } else { }
                    }
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
            ZStack {
                Text(viewModel.userArtist.stagename)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .scaleEffect(1.4)
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button(action: { viewModel.isEditName = true }, label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .padding(.horizontal)
                        })
                    }
                }
            }
            ZStack {
                Text(viewModel.EditUserInfo)
                    .font(.headline)
                    .fontWeight(.heavy)
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button(action: { viewModel.isEditInfo = true }, label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .padding(.horizontal)
                        })
                    }
                }
            }.padding(.bottom, 30)
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
    
    var firstToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button {
                viewModel.isEditMode = false
                //TODO: 취소하는 거 구현
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
        VStack {
            Text("Youtube")
            TextField("", text: $viewModel.userArtist.youtube)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Text("Instagram")
            TextField("", text: $viewModel.userArtist.instagram)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Text("SoundCloud")
            TextField("", text: $viewModel.userArtist.soundcloud)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }.presentationDetents([.medium])
        .padding(.horizontal, 4)
        
    }
    
    var editNameSheet: some View {
        VStack{
            Text("User Name")
            TextField("", text: $viewModel.EditUsername)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Spacer()
        }.presentationDetents([.medium])
            .padding()
    }
    
    var editInfoSheet: some View {
        VStack{
            Text("User Info")
            TextField("", text: $viewModel.EditUserInfo)
                .padding(13)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Spacer()
        }.presentationDetents([.medium])
            .padding()
    }
}
