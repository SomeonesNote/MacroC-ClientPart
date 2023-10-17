//
//  Apitest.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import Alamofire
import SwiftUI

//MARK: -1. PROPERTY

struct TestUserProfile: Encodable, Decodable {
    var email : String
    var username : String
    var password : String
    var avartaUrl : String
    
}

class TestUser: ObservableObject {
    
    @Published var email : String = ""
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var avartaUrl : String = ""
    
}

//MARK: -2 FUNCTION

func sendGetUserProfile(for user: TestUser) {
    
    // userDefaults 값에서 id 값을 가져와서 서버에 id값으로 get 요청 - 추후 accessToken으로 대체
    guard let userid = UserDefaults.standard.value(forKey: "userid") as? Int else {
        print("UserID not found in UserDefaults.")
        return
    }
    
    // DummyData를 넣어놓을 endPoint
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users/\(userid)"
    
    AF.request(url,
               method: .get).responseDecodable(of: TestUserProfile.self) { response in
        switch response.result {
        case .success(let testUserProfile) :
            DispatchQueue.main.async {
                user.email = testUserProfile.email
                user.username = testUserProfile.username
                user.password = testUserProfile.password
                user.avartaUrl = testUserProfile.avartaUrl
            }
        case .failure(let error) :
            print("Error: \(error)")
        }
    }
}

func sendPostRequest(testUserProfile: TestUserProfile) {
    
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users"
    
    AF.request(url,
               method: .post,
               parameters: testUserProfile,
               encoder: JSONParameterEncoder.default).responseDecodable(of: TestUserProfile.self) { response in
        switch response.result {
        case .success(let returnedUserProfile):
            debugPrint(returnedUserProfile)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

func sendDeleteRequest() {
    
    guard let userid = UserDefaults.standard.value(forKey: "userid") as? Int else {
        print("UserID not found in UserDefaults.")
        return
    }
    
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users/\(userid)"
    
    AF.request(url,
               method: .delete).response { response in
        debugPrint(response)
    }
}
