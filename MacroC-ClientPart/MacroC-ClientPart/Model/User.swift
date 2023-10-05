//
//  User.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import MapKit

struct User:  Identifiable, Decodable, Encodable {
    let id: Int
    let email: String
    let username: String
    let password: String
    let avartaUrl: String
}
//    let following: [Busker]
    
//    init(user: User) {
//        self.id = user.id
//        self.email = user.email
//        self.username = user.username
//        self.password = user.password
//        self.avartaUrl = user.avartaUrl
//    }
//}
