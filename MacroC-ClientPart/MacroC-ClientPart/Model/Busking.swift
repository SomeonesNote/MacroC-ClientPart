//
//  Busking.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

struct Busking:  Identifiable, Codable , Hashable{
    var id : Int
    var BuskingStartTime : Date
    var BuskingEndTime : Date
    var stageName: String
    var latitude: Double
    var longitude: Double
    var BuskingInfo : String
    
    init(
        id: Int = 0,
        BuskingStartTime: Date = Date(),
        BuskingEndTime: Date = Date(),
        stageName: String = "",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        BuskingInfo : String = ""
    ) {
        self.id = id
        self.BuskingStartTime = BuskingStartTime
        self.BuskingEndTime = BuskingEndTime
        self.stageName = stageName
        self.latitude = latitude
        self.longitude = longitude
        self.BuskingInfo = BuskingInfo
    }
}

extension Busking {
    init(from busking: Busking) {
        self.id = busking.id
        self.BuskingStartTime = busking.BuskingStartTime
        self.BuskingEndTime = busking.BuskingEndTime
        self.stageName = busking.stageName
        self.latitude = busking.latitude
        self.longitude = busking.longitude
        self.BuskingInfo = busking.BuskingInfo
    }
}
