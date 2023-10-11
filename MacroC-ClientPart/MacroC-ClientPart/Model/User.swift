//
//  User.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import Alamofire

struct User: Codable {
    let id: Int
    let artistid : Int
    let username: String
    let email: String
    let password: String
    let userimage : String
    let follow : [Int]
}
//    let following: [Busker]

//    init(user: User) {
//        self.id = user.id
//        self.email = user.email
//        self.username = user.username
//        self.password = user.password
//        self.avartaUrl = user.avartaUrl
//    }

//let dummy1user = User(id: 1, email: "", username: "", password: "", avartaUrl: "")
//let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users/\(dummy1user.id)"
//
//class userDummyDatatest : ObservableObject {
//    
//    @Published var user: User?
//    
//    func getUserData() {
//        
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: User.self){ response in
//                switch response.result {
//                case .success(let userData) :
//                    self.user = userData
//                case .failure(let error) :
//                    print("Error : \(error)")
//                }
//            }
//    }
//}
