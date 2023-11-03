//
//  ArtistPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

class ArtistPageViewModel: ObservableObject {
    @Published var artist: Artist
    @Published var isfollowing: Bool = false
    init(artist: Artist) {
        self.artist = artist
    }
}
