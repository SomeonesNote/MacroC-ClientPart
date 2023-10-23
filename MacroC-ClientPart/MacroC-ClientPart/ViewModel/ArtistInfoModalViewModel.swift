//
//  ArtistInfoModalViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

class ArtistInfoModalViewModel: ObservableObject {
    @Published var isClickedLike: Bool = false
    @Published var artist: Artist
    
    
    init(busking: Artist) {
        self.artist = busking
    }
    
    func toggleLike() {
        isClickedLike.toggle()
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        if let busking = artist.buskings?.last?.BuskingStartTime {
            return formatter.string(from: busking)
        }
        return ""
    }

    
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        if let busking = artist.buskings?.last?.BuskingStartTime{
            return formatter.string(from: busking)
        }
        return ""
    }
    
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        if let busking = artist.buskings?.last?.BuskingEndTime{
            return formatter.string(from: busking)
        }
        return ""
    }
}
