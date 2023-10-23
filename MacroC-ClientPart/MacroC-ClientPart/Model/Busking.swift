//
//  Busking.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import MapKit

struct Busking:  Identifiable, Codable {
    var id : Int
    var BuskingStartTime : Date
    var BuskingEndTime : Date
    var latitude: Double
    var longitude: Double
    var BuskingInfo : String
    
    init(
        id: Int = 0,
        BuskingStartTime: Date = Date(),
        BuskingEndTime: Date = Date(),
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        BuskingInfo : String = ""
    ) {
        self.id = id
        self.BuskingStartTime = BuskingStartTime
        self.BuskingEndTime = BuskingEndTime
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
        self.latitude = busking.latitude
        self.longitude = busking.longitude
        self.BuskingInfo = busking.BuskingInfo
    }
}
