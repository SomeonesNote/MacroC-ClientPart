//
//  UserArtistProfileSettingViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

class UserArtistProfileSettingViewModel: ObservableObject {
    
    @Published var selectedBusking: Busking = dummyBusking1
    @Published var userArtist: Artist = dummyUserArtist
    
//    @Published var isShowArtistProfile: Bool = false
    @Published var popAddBusking: Bool = false
    @Published var switchNotiToggle: Bool = false
    
}
