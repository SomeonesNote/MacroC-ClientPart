//
//  ArtistProfileViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

class ArtistProfileViewModel: ObservableObject {
    
    @Published var selectedBusking: Busking = dummyBusking1
    @Published var user: User = dummyUser
    
    @Published var isShowArtistProfile: Bool = false
    @Published var isShowAddBusking: Bool = false
    @Published var isOn: Bool = false
    
}
