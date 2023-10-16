//
//  DummyData.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation

//DummyUser
let dummyUser = User(id: 1, artistid: 0, username: "User", email: "user1@google.com", password: "user1.pw", userimage: "User", follow: [])

//DummyUserArtist
let dummyUserArtist = Artist(id: 1, stagename: "UserArtist", artistinfo: "안녕하세요 아이유입니다", artistimage: "UserArtist", youtube: "https://www.youtube.com/@dlwlrma", instagram: "https://www.instagram.com/dlwlrma/", soundcloud: "", genre: "Sing", fanlist: [], member: [])

//Blank User
let blankUser = User(id: 0, artistid: 0, username: "Name", email: "", password: "", userimage: "UserBlank", follow: [])

//Blank Artist
let blankArtist = Artist(id: 0, stagename: "Name", artistinfo: "Artist Information", artistimage: "UserBlank", youtube: "", instagram: "", soundcloud: "", genre: "", fanlist: [], member: [])

//DummyAllArtist
let dummyAllArtist: [Artist] = [dummyArtist1, dummyArtist2, dummyArtist3, dummyArtist4, dummyArtist5]

//DummyArtist
let dummyArtist1 = Artist(id: 2, stagename: "박보영", artistinfo: "안녕하세요 박보영입니다", artistimage: "Busker1", youtube: "https://www.youtube.com/@Bbovely_", instagram: "https://www.instagram.com/park_bo_young_/", soundcloud: "soundcloud", genre: "Sing", fanlist: [], member: [])
let dummyArtist2 = Artist(id: 3, stagename: "NewJeans", artistinfo: "안녕하세요 뉴진스입니다", artistimage: "Busker2", youtube: "https://www.youtube.com/@NewJeans_official", instagram: "https://www.instagram.com/newjeans.updates/", soundcloud: "soundcloud", genre: "Sing", fanlist: [], member: [])
let dummyArtist3 = Artist(id: 4, stagename: "SunMe", artistinfo: "안녕하세요 선미입니다", artistimage: "Busker3", youtube: "https://www.youtube.com/@sunmi_official", instagram: "https://www.instagram.com/miyayeah/", soundcloud: "soundcloud", genre: "Sing", fanlist: [], member: [])
let dummyArtist4 = Artist(id: 5, stagename: "AKB48", artistinfo: "안녕하세요 AKB48입니다", artistimage: "Busker4", youtube: "https://www.youtube.com/@akb48", instagram: "https://www.instagram.com/akb48/", soundcloud: "soundcloud", genre: "Sing", fanlist: [], member: [])
let dummyArtist5 = Artist(id: 6, stagename: "김채원", artistinfo: "안녕하세요 김채원입니다", artistimage: "Busker5", youtube: "https://www.youtube.com/@LESSERAFIM_official", instagram: "https://www.instagram.com/_chaechae_1/", soundcloud: "soundcloud", genre: "Sing", fanlist: [], member: [])
let dummyBuskingNow: [Busking] = [dummyBusking1,dummyBusking2,dummyBusking3,dummyBusking4,dummyBusking5]

let dummyBuskingEmpty: [Busking] = []

//DummyBusking
let dummyBusking1 = Busking(id: 1, artistname: "박보영", artistimage: "Busker1", buskingstarttime: Date(), buskingendtime: Date(), latitude: 37.557192, longitude: 126.925381, buskinginfo: "안녕하세요 박보영입니다")
let dummyBusking2 = Busking(id: 2, artistname: "NewJeans", artistimage: "Busker2", buskingstarttime: Date(), buskingendtime: Date(), latitude: 37.557777, longitude: 126.925536, buskinginfo: "안녕하세요 뉴진스입니다")
let dummyBusking3 = Busking(id: 3, artistname: "SunMe", artistimage: "Busker3", buskingstarttime: Date(), buskingendtime: Date(), latitude: 37.557282, longitude: 126.926091, buskinginfo: "안녕하세요 선미입니다")
let dummyBusking4 = Busking(id: 4, artistname: "AKB48", artistimage: "Busker4", buskingstarttime: Date(), buskingendtime: Date(), latitude: 37.557892, longitude: 126.924338, buskinginfo: "안녕하세요 AKB48입니다")
let dummyBusking5 = Busking(id: 5, artistname: "김채원", artistimage: "Busker5", buskingstarttime: Date(), buskingendtime: Date(), latitude: 36.054547008708475, longitude: 129.3770062292809, buskinginfo: "안녕하세요 김채원입니다")

//DummyUserFollowing
let dummyUserFollowing : [Artist] = [dummyArtist1, dummyArtist2, dummyArtist3, dummyArtist4, dummyArtist5]

//EmptyUserFollowing
let dummyEmptyFollowing : [Artist] = []

