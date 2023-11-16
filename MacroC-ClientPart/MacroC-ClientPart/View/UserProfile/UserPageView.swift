//
//  UserPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/16.
//

import SwiftUI
import PhotosUI

struct UserPageView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @StateObject var viewModel = UserPageViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(5)) {
                    if viewModel.croppedImage != nil { pickedImage }
                    else { artistPageImage }
                    userPageTitle
                    Spacer()
                }
            }.blur(radius: viewModel.isEditName || viewModel.isEditInfo ? 15 : 0)
            if viewModel.isEditName || viewModel.isEditInfo {
                Color.black.opacity(0.1)
                    .onTapGesture {
                        viewModel.isEditName = false
                        viewModel.isEditInfo = false
                    }
            }
            if viewModel.isEditName {
                editNameSheet
            }
            if viewModel.nameSaveOKModal {
                PopOverText(text: "저장되었습니다")
            }
            if viewModel.infoSaveOKModal {
                PopOverText(text: "저장되었습니다")
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { firstToolbarItem.opacity(viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
            ToolbarItem(placement: .topBarTrailing) { secondToolbarItem.opacity(viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
        }
        .onAppear {
            if let url = URL(string: awsService.user.avatarUrl) {
                loadImage(from: url)}
            viewModel.EditUsername = awsService.user.username
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
                viewModel.copppedImageData = data
                viewModel.croppedImage = uiImage
                viewModel.popImagePicker = false
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTitle("")
    }
}

//MARK: -4.EXTENSION
extension UserPageView {
    var artistPageImage: some View {
        AsyncImage(url: URL(string: awsService.user.avatarUrl)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        .overlay(alignment: .bottom) {
            if viewModel.isEditMode {
                Button{
                    viewModel.popImagePicker = true
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.custom40bold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    
    var pickedImage: some View {
        Image(uiImage: viewModel.croppedImage!)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    PhotosPicker(
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.circle.fill")
                                .font(.custom40bold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        }
                }
            }
    }
    
    var userPageTitle: some View {
        return VStack{
            ZStack {
                Text(awsService.user.username)
                    .font(.custom40black())
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.isEditName = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var firstToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button {
                viewModel.isEditMode = false
                viewModel.croppedImage = nil
                viewModel.isEditName = false
                viewModel.isEditInfo = false
            } label: {
                toolbarButtonLabel(buttonLabel: "Cancle").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var secondToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button{
                
                viewModel.isEditMode = false
                viewModel.isEditName = false
                viewModel.isEditInfo = false
                
                awsService.patchcroppedImage = viewModel.croppedImage
                awsService.patchUserProfile()
            } label: {
                toolbarButtonLabel(buttonLabel: "Save").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(Button{
                viewModel.isEditMode = true
            } label: {
                toolbarButtonLabel(buttonLabel: "Edit").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
            })
        }
    }
    
    var editNameSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("User name").font(.custom14semibold())
            }
            TextField(awsService.user.username, text: $viewModel.EditUsername)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            Button {
                awsService.user.username = viewModel.EditUsername
                viewModel.nameSaveOKModal = true
                withAnimation(.smooth(duration: 0.5)) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.nameSaveOKModal = false
                        viewModel.isEditName = false
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    viewModel.croppedImage = image
                }
            }
        }.resume()
    }
}
