//
//  DummyData.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

//DummyUser
let dummyUser = User(id: 1, username: "User", email: "user1@google.com", password: "user1.pw", avatarUrl: "User", artist: dummyUserArtist)

//DummyUserArtist
let dummyUserArtist = Artist(id: 1, stageName: "UserArtist", artistInfo: "안녕하세요 아이유입니다", artistImage: "UserArtist", genres: "Sing", members: [], buskings: [])

//Blank User
let blankUser = User(id: 0, username: "Name", email: "", password: "", avatarUrl: "UserBlank", artist: blankArtist)

//Blank Artist
let blankArtist = Artist(id: 0, stageName: "Name", artistInfo: "Artist Information", artistImage: "UserBlank", genres: "", members: [], buskings: [])

//DummyAllArtist
let dummyAllArtist: [Artist] = [dummyArtist1, dummyArtist2, dummyArtist3, dummyArtist4, dummyArtist5]

//DummyArtist
let dummyArtist1 = Artist(id: 2, stageName: "박보영", artistInfo: "안녕하세요 박보영입니다", artistImage: "Busker1", genres: "Sing", members: [], buskings: [])
let dummyArtist2 = Artist(id: 3, stageName: "NewJeans", artistInfo: "안녕하세요 뉴진스입니다", artistImage: "Busker2", genres: "Sing", members: [], buskings: [])
let dummyArtist3 = Artist(id: 4, stageName: "SunMe", artistInfo: "안녕하세요 선미입니다", artistImage: "Busker3", genres: "Sing", members: [], buskings: [])
let dummyArtist4 = Artist(id: 5, stageName: "AKB48", artistInfo: "안녕하세요 AKB48입니다", artistImage: "Busker4", genres: "Sing", members: [], buskings: [])
let dummyArtist5 = Artist(id: 6, stageName: "김채원", artistInfo: "안녕하세요 김채원입니다", artistImage: "Busker5", genres: "Sing", members: [], buskings: [])
let dummyBuskingNow: [Busking] = [dummyBusking1,dummyBusking2,dummyBusking3,dummyBusking4,dummyBusking5]

let dummyBuskingEmpty: [Busking] = []

//DummyBusking

let dummyBusking1 = Busking(id: 1, BuskingStartTime: Date(), BuskingEndTime: Date(), latitude: 37.557192, longitude: 126.925381, BuskingInfo: "안녕하세요 박보영입니다")
let dummyBusking2 = Busking(id: 2, BuskingStartTime: Date(), BuskingEndTime: Date(), latitude: 37.557777, longitude: 126.925536, BuskingInfo: "안녕하세요 뉴진스입니다")
let dummyBusking3 = Busking(id: 3, BuskingStartTime: Date(), BuskingEndTime: Date(), latitude: 37.557282, longitude: 126.926091, BuskingInfo: "안녕하세요 선미입니다")
let dummyBusking4 = Busking(id: 4, BuskingStartTime: Date(), BuskingEndTime: Date(), latitude: 37.557892, longitude: 126.924338, BuskingInfo: "안녕하세요 AKB48입니다")
let dummyBusking5 = Busking(id: 5, BuskingStartTime: Date(), BuskingEndTime: Date(), latitude: 36.054547008708475, longitude: 129.3770062292809, BuskingInfo: "안녕하세요 김채원입니다")

//DummyUserFollowing
let dummyUserFollowing : [Artist] = [dummyArtist1, dummyArtist2, dummyArtist3, dummyArtist4, dummyArtist5]

//EmptyUserFollowing
let dummyEmptyFollowing : [Artist] = []

