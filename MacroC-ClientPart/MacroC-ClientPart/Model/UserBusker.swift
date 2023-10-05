//
//  UserBusker.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import MapKit

struct UserBusker: Identifiable {
    let id: Int
    let email: String
    let username: String
    let password: String
    let avartaUrl: String
    
    var youtube: String = ""
    var instagram: String = ""
    var soundcloud: String = ""
    
    var buskerInfo: String = ""
}
