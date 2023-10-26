//
//  Artist.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

struct Artist: Identifiable, Codable {
    
    var id: Int
    var stageName : String
    var artistInfo : String
    var artistImage : String
    
    var genres : String
    var members : [Member]?
    var buskings : [Busking]?
    
//    var youtube: String
//    var instagram: String
//    var soundcloud: String
//    let genre : String
    
    init(id: Int = 0,
         stageName: String = "",
         artistInfo: String = "",
         artistImage: String = "",
         genres: String = "",
         members: [Member] = [],
         buskings: [Busking] = []
    ) {
        self.id = id
        self.stageName = stageName
        self.artistInfo = artistInfo
        self.artistImage = artistImage
        self.genres = genres
        self.members = members
        self.buskings = buskings
    }
}

extension Artist {
    init(from artist: Artist) {
        self.id = artist.id
        self.artistInfo = artist.artistInfo
        self.stageName = artist.stageName
        self.artistImage = artist.artistImage
        self.genres = artist.genres
        self.members = artist.members
        self.buskings = artist.buskings
    }
}
