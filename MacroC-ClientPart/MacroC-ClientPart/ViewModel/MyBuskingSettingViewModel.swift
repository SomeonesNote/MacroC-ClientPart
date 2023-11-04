//
//  MyBuskingSettingViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/11/03.
//

import Foundation

class MyBuskingSettingViewModel: ObservableObject {
    @Published var popBuskingModal: Bool = false
    @Published var selectedBusking: Busking = Busking()
    @Published var selectedArtist: Artist = Artist()
    @Published var following: [Artist] = []
    @Published var nowBusking: [Busking] = []
    @Published var isEditMode: Bool = false
    @Published var deleteAlert: Bool = false
}

