//
//  ArtistInfoModalViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

class ArtistInfoModalViewModel: ObservableObject {
    @Published var isClickedLike: Bool = false
    @Published var busking: Busking

    init(busking: Busking) {
        self.busking = busking
    }

    func toggleLike() {
        isClickedLike.toggle()
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: busking.buskingstarttime)
    }
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: busking.buskingstarttime)
    }
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        return formatter.string(from: busking.buskingendtime)
    }
}
