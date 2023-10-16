//
//  UserArtistPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

class UserArtistPageViewModel: ObservableObject {
    @Published var userArtist: Artist
    @Published var isEditMode: Bool = false
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popImagePicker: Bool = false
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage?
    @Published var isLoading: Bool = false
    
    @Published var isEditSocial: Bool = false
    @Published var isEditName: Bool = false
    @Published var isEditInfo: Bool = false
    
    @Published var EditUsername: String = "User"
    @Published var EditUserInfo: String = "Simple Imforamtion of This Artist"
    
    @Published var socialSaveOKModal: Bool = false
    @Published var nameSaveOKModal: Bool = false
    @Published var infoSaveOKModal: Bool = false

    init(userArtist: Artist) {
        self.userArtist = userArtist
    }
    
    func toggleEditMode() {
        isEditMode.toggle()
    }

    func cancelEditMode() {
        isEditMode = false
        selectedItem = nil
        selectedPhotoData = nil
        croppedImage = nil
    }

    func saveEditMode() {
        isEditMode = false
        //TODO: 세이브하는 거 구현
    }
}
