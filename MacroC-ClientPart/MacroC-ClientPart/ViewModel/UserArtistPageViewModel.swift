//
//  UserArtistPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

class UserArtistPageViewModel: ObservableObject {
    
    @Published var isEditMode: Bool = true
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popImagePicker: Bool = false
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage?
    @Published var isLoading: Bool = false
    
    @Published var socialSaveOKModal: Bool = false
    @Published var nameSaveOKModal: Bool = false
    @Published var infoSaveOKModal: Bool = false
    
    @Published var isEditSocial: Bool = false
    @Published var isEditName: Bool = false
    @Published var isEditInfo: Bool = false
    
    @Published var youtubeURL: String
    @Published var instagramURL: String
    @Published var soundcloudURL: String
    
    @Published var editUsername: String = ""
    @Published var editUserInfo: String = ""
    
    init(youtubeURL: String = "" , instagramURL: String = "" , soundcloudURL: String = "") {
        self.youtubeURL = youtubeURL
        self.instagramURL = instagramURL
        self.soundcloudURL = soundcloudURL
    }
}
