//
//  BuskerPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

class BuskerPageViewModel: ObservableObject {
    @Published var artist: Artist

    init(busker: Artist) {
        self.artist = busker
    }
}
