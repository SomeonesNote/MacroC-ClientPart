//
//  ProfileSettingViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

class ProfileSettingViewModel: ObservableObject {
    
    @Published var switchNotiToggle = false
    @Published var isArtistAccount = true
    @Published var popArtistProfile: Bool = false
    
}
