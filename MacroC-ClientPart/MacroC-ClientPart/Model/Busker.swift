//
//  Busker.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

struct Busker: Codable, Identifiable {
    var id: UUID
    var name: String
    var image: String
    
    var youtube: String
    var instagram: String
    var soundcloud: String
    
    var buskerInfo: String
    
}
