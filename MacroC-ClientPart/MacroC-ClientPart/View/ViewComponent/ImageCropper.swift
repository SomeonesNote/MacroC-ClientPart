//
//  ImageCropper.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

//MARK: view extension
extension View {
    @ViewBuilder
    func cropImagePicker(show: Binding<Bool>, croppedImage: Binding<UIImage?>, isLoding: Binding<Bool>) -> some View {
        CustomImagePicker(show: show, croppedImage: croppedImage, isLoading: isLoding) {
            self
        }
    }
        func checkAlbumPermission(){
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    print("Album: authorized")
                case .denied:
                    print("Album: denied")
                case .restricted, .notDetermined:
                    print("Album: \(status)")
                default:
                    break
                }
            })
        }

    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}



fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    @Binding var isLoading: Bool
    
    init(show: Binding<Bool>, croppedImage: Binding<UIImage?>, isLoading: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self._isLoading = isLoading
    }
    
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCropView: Bool = false
    
    
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { newValue in
                isLoading = true
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            await MainActor.run(body: {
                                selectedImage = image
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showCropView = true
                                    isLoading = false
                                }
                            })
                        } else {
                            isLoading = false
                        }
                    }
                } else {
                    isLoading = false
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
            } content: {
                CropView(image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

struct CropView: View {
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    let cropSize = CGSize(width: UIScreen.getWidth(390), height: UIScreen.getHeight(390))
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    
    var body: some View{
        NavigationStack{
            VStack{
                ImageView()
                    .navigationTitle("Crop View")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background{ backgroundView().ignoresSafeArea() }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                let renderer = ImageRenderer(content: ImageView(hideGrids: true))
                                renderer.proposedSize = .init(cropSize)
                                if let image =  renderer.uiImage{
                                    onCrop(image,true)
                                }else{
                                    onCrop(nil,false)
                                }
                                dismiss()
                            } label: {
                                Image(systemName: "checkmark")
                                    .font(.custom18semibold())
                            }
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement:.navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.custom18semibold())
                            }
                        }
                    }
            }
        }
    }
    
    @ViewBuilder func ImageView(hideGrids:Bool = false)->some View{
        let cropSize = cropSize
        GeometryReader{
            let size = $0.size
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content:{
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        
                                        if rect.minX > 0{
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.minY > 0{
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxX < size.width{
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxY < size.height{
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    if !newValue{
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }).frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting,body:{ _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width+lastStoredOffset.width, height: translation.height+lastStoredOffset.width)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ valuea in
                    withAnimation(.easeInOut(duration: 0.02)){
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        }else{
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .cornerRadius(UIScreen.getWidth(5))
        .overlay {
            Rectangle().stroke(lineWidth: UIScreen.getWidth(1))
        }
    }
}
