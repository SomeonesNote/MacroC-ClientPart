//
//  UserDefualts.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/09.
//

import Foundation

struct UserResponse: Decodable {
    let buskerID: Int
    let userID: Int
    let isSigned: Bool
    let isSignup: Bool
    let isSignedBukser: Bool
}
