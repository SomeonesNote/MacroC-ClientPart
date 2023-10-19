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
//    @Published var user: User = dummyUser
    @Published var user : TestUser = SignUpViewModel().getUserProfile()
    
//    init(switchNotiToggle: Bool = false, isArtistAccount: Bool = true, popArtistProfile: Bool, user: TestUser) {
//
//        self.switchNotiToggle = switchNotiToggle
//        self.isArtistAccount = isArtistAccount
//        self.popArtistProfile = popArtistProfile
//        self.user = user
//    }
}
