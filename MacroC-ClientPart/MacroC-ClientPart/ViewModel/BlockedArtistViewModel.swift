//
//  BlockedArtistViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/11/12.
//

import Foundation

class BlockedArtistViewModel: ObservableObject {
    @Published var artist: Artist
    @Published var isfollowing: Bool = false
    init(artist: Artist) {
        self.artist = artist
    }
}
