//
//  BuskerApiTest.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/08.
//

import Foundation
import Alamofire
import SwiftUI

//MARK: -1. PROPERTY

struct TestBuskerProfile: Encodable, Decodable  {
    
    var name: String
    var image: String
    
    var youtube: String
    var instagram: String
    var soundcloud: String
    
    var buskerInfo: String
    
}

class TestBusker: ObservableObject {
    
    @Published var name: String = ""
    @Published var image: String = ""
    
    @Published var youtube: String = ""
    @Published var instagam: String = ""
    @Published var soundcloud: String = ""
    
    @Published var buskerInfo : String = ""
    
}

//MARK: -2 FUNCTION

func sendGetBuskerProfile(for busker: TestBusker) {
    
    guard let buskerid = UserDefaults.standard.value(forKey: "buskerid") as? Int else {
        print("BuskerID not found in UserDefaults")
        return
    }
    
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/busker/\(buskerid)"
    
    AF.request(url,
               method: .get).responseDecodable(of: TestBuskerProfile.self) { response in
        switch response.result {
        case .success(let testBuskerProfile):
            DispatchQueue.main.async {
                busker.name = testBuskerProfile.name
                busker.image = testBuskerProfile.image
                busker.youtube = testBuskerProfile.youtube
                busker.instagam = testBuskerProfile.instagram
                busker.soundcloud = testBuskerProfile.soundcloud
                busker.buskerInfo = testBuskerProfile.buskerInfo
            }
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

func sendPostBuskerProfile(testBuserProfile: TestBuskerProfile) {
    
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/busker"
    
    AF.request(url,
               method: .post,
               parameters: testBuserProfile,
               encoder: JSONParameterEncoder.default).responseDecodable(of: UserResponse.self) { response in
        switch response.result {
        case .success(let returnedData):
            UserDefaults.standard.set(returnedData.buskerID, forKey: "buskerid")
            UserDefaults.standard.set(true, forKey: "isSignedBusker")
            print(returnedData)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

func sendDeleteBuskerAcount() {
    
    guard let buskerid = UserDefaults.standard.value(forKey: "buskerid") as? Int else {
        print("BuskerID not found in UserDefaults.")
        return
    }
    
    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/busker/\(buskerid)"
    
    AF.request(url,
               method: .delete).response { response in
        if let statusCode = response.response?.statusCode {
               switch statusCode {
               case 200...299:  // 성공적인 상태 코드 범위
                   UserDefaults.standard.set(false, forKey: "isSignedBusker")
                   UserDefaults.standard.set(nil, forKey: "buskerID")
               default:
                   print("Server returned status code: \(statusCode)")
               }
           }
        else if let error = response.error {
               print("Error: \(error)")
        }
    }
}
