//
//  MainViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/09.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var popBuskingModal: Bool = false
    @Published var selectedBusking: Busking = Busking()
    @Published var selectedArtist: Artist = Artist()
    @Published var following: [Artist] = []
    @Published var nowBusking: [Busking] = []

}
