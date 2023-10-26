//
//  PhotoTest.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerContent: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State var uiImage: UIImage?
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .any(of: [.images, .not(.livePhotos)]),
                photoLibrary: .shared()) {
                    Text("Select a photo from PhotoPicker")
                }
            if uiImage != nil {
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                }
            }
        .onChange(of: selectedPhoto) { result in
            Task {
                do {
                    if let data = try await selectedPhoto?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            self.uiImage = uiImage
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    selectedPhoto = nil
                }
            }
        }
    }
}
