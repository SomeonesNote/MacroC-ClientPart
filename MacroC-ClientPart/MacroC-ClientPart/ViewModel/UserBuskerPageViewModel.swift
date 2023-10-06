//
//  UserBuskerPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

class UserBuskerPageViewModel: ObservableObject {
    @Published var userBusker: UserBusker
    @Published var isEditMode: Bool = false
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popCrop: Bool = false
    @Published var popCropImage: Data?
    @Published var croppedImage: UIImage?
    @Published var isLoading: Bool = false

    init(userBusker: UserBusker) {
        self.userBusker = userBusker
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
