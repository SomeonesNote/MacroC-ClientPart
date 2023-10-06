//
//  User.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import MapKit
import Alamofire


let dummy1user = User(id: 1, email: "", username: "", password: "", avartaUrl: "")

let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users/\(dummy1user.id)"

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

class userDummyDatatest : ObservableObject {
    
    @Published var user: User?
    
    func getUserData() {
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: User.self){ response in
                switch response.result {
                case .success(let userData) :
                    self.user = userData
                case .failure(let error) :
                    print("Error : \(error)")
                }
            }
    }
}
