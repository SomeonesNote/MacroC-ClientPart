//
//  DummyData.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

//let dummyUser = User(name: "User", image: "User", following: [dummyBusker1,dummyBusker2,dummyBusker3,dummyBusker4,dummyBusker5]) // 더미 팔로잉으로 일단 대체
let dummyUser = User(id: 1, email: "User", username: "User", password: "User", avartaUrl: "User")

let dummyUserBusker = UserBusker(id: 1, email: "User", username: "User", password: "User", avartaUrl: "User")

let dummyBusker1 = Busker(id: UUID(), name: "박보영", image: "Busker1", youtube: "https://www.youtube.com/@Bbovely_", instagram: "https://www.instagram.com/park_bo_young_/", soundcloud: "soundcloud", buskerInfo: "안녕하세요 박보영입니다")
let dummyBusker2 = Busker(id: UUID(), name: "NewJeans", image: "Busker2", youtube: "https://www.youtube.com/@NewJeans_official", instagram: "https://www.instagram.com/newjeans.updates/", soundcloud: "soundcloud", buskerInfo: "안녕하세요 뉴진스입니다")
let dummyBusker3 = Busker(id: UUID(), name: "SunMe", image: "Busker3", youtube: "https://www.youtube.com/@sunmi_official", instagram: "https://www.instagram.com/miyayeah/", soundcloud: "soundcloud", buskerInfo: "안녕하세요 선미입니다")
let dummyBusker4 = Busker(id: UUID(), name: "AKB48", image: "Busker4", youtube: "https://www.youtube.com/@akb48", instagram: "https://www.instagram.com/akb48/", soundcloud: "soundcloud", buskerInfo: "안녕하세요 AKB48입니다")
let dummyBusker5 = Busker(id: UUID(), name: "김채원", image: "Busker5", youtube: "https://www.youtube.com/@LESSERAFIM_official", instagram: "https://www.instagram.com/_chaechae_1/", soundcloud: "soundcloud", buskerInfo: "안녕하세요 김채원입니다")

let dummyBuskingNow: [Busking] = [dummyBusking1,dummyBusking2,dummyBusking3,dummyBusking4,dummyBusking5]

let dummyBusking1 = Busking(id: UUID(), name: "박보영", image: "Busker1", time: "12:00 ~ 14:00", latitude: 37.557192, longitude: 126.925381)
let dummyBusking2 = Busking(id: UUID(), name: "NewJeans", image: "Busker2", time: "12:00 ~ 14:00", latitude: 37.557777, longitude: 126.925536)
let dummyBusking3 = Busking(id: UUID(), name: "SunMe", image: "Busker3", time: "12:00 ~ 14:00", latitude: 37.557282, longitude: 126.926091)
let dummyBusking4 = Busking(id: UUID(), name: "AKB48", image: "Busker4", time: "12:00 ~ 14:00", latitude: 37.557892, longitude: 126.924338)
let dummyBusking5 = Busking(id: UUID(), name: "김채원", image: "Busker5", time: "12:00 ~ 14:00", latitude: 36.054547008708475, longitude: 129.3770062292809)

let dummyUserFollowing : [Busker] = [dummyBusker1,dummyBusker2,dummyBusker3,dummyBusker4,dummyBusker5]
//
//struct dummyUser1: User {
//    let id = 1
//    let email = "google.com"
//    let username = "아이유님"
//    let password = "1234"
//    let avartaUrl = "User"
//}
