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
    func cropImagePicker(show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    // for making it simple and easy to use
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    // haptic feedback
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}



fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    
    init(show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
    }
    
    // view properties
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCropView: Bool = false
    
    
    var body: some View {
         content
             .photosPicker(isPresented: $show, selection: $photosItem)
             .onChange(of: photosItem) { newValue in
                 // extracting ui image from photos view
                 if let newValue {
                     Task {
                         if let imageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                             // UI must be updated on main thread
                             await MainActor.run(body: {
                                 selectedImage = image
                                 showCropView.toggle()
                             })
                         }
                     }
                 }
             }
             .fullScreenCover(isPresented: $showCropView) {
                 // when exited clearing the old selected image
                 selectedImage = nil
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
    var onCrop: (UIImage?, Bool) -> () // this call back will give the cropped image and result status when the checkmark button is pressed
    
    // crop view view properties
    @Environment(\.dismiss) private var dismiss
    // crop view Gesture properties
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    let cropSize = CGSize(width: 300, height: 300)
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false // indicates that whether or not the gesture is in interaction
    
    
    var body: some View{
        NavigationStack{
            VStack{
                ImageView()
                    .navigationTitle("Crop View")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color.black, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background{
                        Color.black
                            .ignoresSafeArea()
                    }
                
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                //converting cropped view to image(native ios 16+)
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
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }

                        }
                    }
                
                    .toolbar{
                        ToolbarItem(placement:.navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }

                        }
                    }
                
            }
        }
    }
    
    //Image view
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
                            Color.clear//so since i used ovelay before the .frame() , it will give the image natural size thus helping us find its edges (top , left ,right , and bottom). ; ; coordinateSpace ensures that it will calculate its rect from the given view and not from the global view
                                .onChange(of: isInteracting) { newValue in//so why no to use onEnded(),instead of this ?  , Because of my usage , onEnd() does not always call ,but updating() is called whenever a gesture is updated , so i didn't use onEnded()
                                    //true dragging
                                    //false stopped Dragging
                                    //We can now read the minX,Y of the image
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        
                                        ///so consider that min X is above zero , like 45 ,and if we set offset to 0, then it will reset to its initial state ,so reducing the minX from the offset will set image to its start
                                        ///example : minX= 45 ; width of offset = 145; as a result we must remove the excess 45 by doing offset.width - minX
                                        ///#minX;minY
                                        
                                    
                                        if rect.minX > 0{
                                            //resetting to last location
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.minY > 0{
                                            //resetting to last location
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        ///so , since maxX is less than the images width , say 230 ,and images width is 300 , we need to reset at its its extent , lets see how
                                        ///example: offset.width= -110 ,image width= 300 ,minX=-150,maxX= 230;
                                        ///Thus doing (imageWidth-maxX) + offset.width will give the extend's offset, but instead of doing this ,
                                        ///we simply did (minX-offset.width) - - - essentially we will get the same resutl.
                                        ///(300-230) - 110 = -40 || (-150+110) = -40
                                        
                                        /// - Doing the same for maxX,Y
                                        //resetting to last location
                                        if rect.maxX < size.width{
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        //resetting to last location
                                        if rect.maxY < size.height{
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    if !newValue{
                                        //storing last offset
                                        lastStoredOffset = offset
                                    }
                                }
                            
                        }
                    })
                    .frame(size)
                
            }
        }
        .scaleEffect(scale)
        .offset(offset)
//        .overlay(content:{
//            //Grids()
//            ///hided above because We dont need grids for cropped images
//            if !hideGrids{
//                Grids()
//            }
//        })
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting,body:{ _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width+lastStoredOffset.width, height: translation.height+lastStoredOffset.width)
                    print("offset ooooo")
                    print(offset)
                })
        )
        .gesture(
        MagnificationGesture()
            .updating($isInteracting, body: { _, out, _ in
                out = true
            }).onChanged({ value in
                let updatedScale = value + lastScale
                //limiting Beyond 1
                scale = (updatedScale < 1 ? 1 : updatedScale)
                print(scale)
                print("above is scale")
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
        .cornerRadius(0)
    }
    
//    @ViewBuilder
//    func Grids()->some View{
//        ZStack{
//            HStack{
//                ForEach(1...2,id:\.self){_ in
//                    Rectangle()
//                        .fill(.white.opacity(0.7))
//                        .frame(width: 1)
//                        .frame(maxWidth: .infinity)
//
//                }
//            }
//
//            VStack{
//                ForEach(1...2,id:\.self){_ in
//                    Rectangle()
//                        .fill(.white.opacity(0.7))
//                        .frame(height: 1)
//                        .frame(maxHeight: .infinity)
//
//                }
//            }
//
//        }
//    }
}

struct CustomImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        CropView(image: UIImage(named: "samplePic1")) { _, _ in }
    }
}
