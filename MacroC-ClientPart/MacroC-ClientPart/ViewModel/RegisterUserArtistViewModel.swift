//
//  RegisterUserArtistViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/27.
//

import SwiftUI
import PhotosUI
import Alamofire

class RegisterUserArtistViewModel: ObservableObject {
    
    @Published var isEditMode: Bool = true
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popImagePicker: Bool = false
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage?
    @Published var isLoading: Bool = false
    
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    
    @Published var artistName: String = ""
    @Published var artistInfo : String = ""
    @Published var genres: String = ""
    
    @Published var youtubeURL: String = ""
    @Published var instagramURL: String = ""
    @Published var soundcloudURL: String = ""
    
}
