//
//  MapBuskerInfoViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

class MapBuskerInfoViewModel: ObservableObject {
    @Published var isClickedLike: Bool = false
    @Published var busking: Busking

    init(busking: Busking) {
        self.busking = busking
    }

    func toggleLike() {
        isClickedLike.toggle()
    }
}
