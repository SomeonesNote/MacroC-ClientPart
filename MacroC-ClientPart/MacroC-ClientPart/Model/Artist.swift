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
    
    var youtubeURL: String?
    var instagramURL: String?
    var soundcloudURL: String?
    
    init(id: Int = 0,
         stageName: String = "",
         artistInfo: String = "",
         artistImage: String = "",
         genres: String = "",
         youtubeURL: String = "",
         instagramURL: String = "",
         soundcloudURL: String = "",
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
        self.youtubeURL = youtubeURL
        self.instagramURL = instagramURL
        self.soundcloudURL = soundcloudURL
    }
}
