//
//  Artist.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

struct Artist: Identifiable ,Codable {
    var id: Int
    let stagename : String
    let artistInfo : String
    let artistimage : String
    
    var youtube: String
    var instagram: String
    var soundcloud: String
    let genre : String
    
    let fanlist : [Int]
    let member : [String]
    
}
