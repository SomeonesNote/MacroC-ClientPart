//
//  User.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import Alamofire

struct User: Codable {
    var id: Int
    var username: String
    var email: String
    var password: String
    var avatarUrl : String
    var artist : Artist
    
    init(id: Int = 0,
    username: String = "",
    email: String = "",
    password: String = "",
    avatarUrl : String = "",
         artist : Artist = Artist()
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.avatarUrl = avatarUrl
        self.artist = artist
    }
}

extension User {
    init(from user: User) {
        self.id = user.id
        self.username = user.username
        self.email = user.email
        self.password = user.password
        self.avatarUrl = user.avatarUrl
        self.artist = user.artist
    }
}

