//
//  Member.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//
//
import Foundation

struct Member : Codable {
    var id : Int
    var membername : String
    var memberimage : String
    var memberinfo : String
    
    init() {
        self.id = 0
        self.membername = ""
        self.memberinfo = ""
        self.memberimage = ""
    }
}

extension Member {
    init(from member: Member) {
        self.id = member.id
        self.membername = member.membername
        self.memberinfo = member.memberinfo
        self.memberimage = member.memberimage
    }
}
