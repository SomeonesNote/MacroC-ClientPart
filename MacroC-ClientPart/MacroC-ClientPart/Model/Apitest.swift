//
//  Apitest.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//
//
//import Foundation
//import Alamofire
//import SwiftUI
//
//
//struct userDelete: Encodable {
//    var id: String
//}
//
//let userid = userDelete(id: "1")
//
//let user = User(id: 1, email: "donbanock@gmail.com", username: "Donbanock", password: "12345", avartaUrl: "donbanock.img.com")
//
//
//func sendPostRequest(user: User) {
//    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users"
//    
//    AF.request(url,
//               method: .post,
//               parameters: user,
//               encoder: JSONParameterEncoder.default).response { response in
//        debugPrint(response)
//    }
//}
//
//func sendDeleteRequest(userid: Int) {
//    let url = "http://ec2-3-37-89-214.ap-northeast-2.compute.amazonaws.com/users/\(userid)"
//    
//    AF.request(url,
//               method: .delete).response { response in
//        debugPrint(response)
//    }
//}
//
//
//struct Apitest: View {
//    var body: some View {
//        
//        Button("저장", action: {
//            sendPostRequest(user: user)
//            
//            print("send")
//        })
//        .padding(.all, 50)
//        
//        Button("삭제", action: {
//            sendDeleteRequest(userid: dummy1user.id)
//            print("send")
//        })
//        .padding(.all, 50)
//    }
//}
//
//#Preview {
//    Apitest()
//}
