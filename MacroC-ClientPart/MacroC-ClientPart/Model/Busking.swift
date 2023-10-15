//
//  Busking.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import MapKit

struct Busking:  Identifiable, Codable {
    //ArtistInfo
    let id : Int
    
    //이거진짜 없어도 되나여
    let artistname: String
    let artistimage: String
    
    //TimeInfo
    let buskingstarttime : Date
    let buskingendtime : Date
    
    //LocationInfo
    var latitude: Double
    var longitude: Double
    
    let buskinginfo : String
}
