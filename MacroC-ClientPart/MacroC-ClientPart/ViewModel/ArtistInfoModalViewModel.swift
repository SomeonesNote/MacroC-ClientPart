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
    @Published var buskingStartTime: Date
    @Published var buskingEndTime: Date
    
    
    init(artist: Artist, buskingStartTime: Date ,buskingEndTime: Date ) {
        self.artist = artist
        self.buskingStartTime = buskingStartTime
        self.buskingEndTime = buskingEndTime
    }
    
    func toggleLike() {
        isClickedLike.toggle()
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        let busking = buskingStartTime
            return formatter.string(from: busking)
        
    }

    
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        let busking = buskingStartTime
            return formatter.string(from: busking)
    }
    
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        let busking = buskingEndTime
            return formatter.string(from: busking)
    }
}
