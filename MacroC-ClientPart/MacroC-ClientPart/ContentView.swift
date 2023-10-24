//
//  ContentView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ContentView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    
    //MARK: -2.BODY
    var body: some View {
        
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Main")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            ProfileSettingView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .onAppear {
            awsService.getUserProfile { //유저프로필 가져오기
                print("2.userArtist : success")
                awsService.getFollowingList { //팔로우 리스트 가져오기
                    print("3.following: success") }}
            awsService.getAllArtistList{
                print("4.allArtist: success")
            }
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }// 탭이 이동할 때 탭바의 백그라운드가 씹히는 것을 막는 위해 추가
    }
}

//MARK: -3.PREVIEW
#Preview {
    ContentView()
}
