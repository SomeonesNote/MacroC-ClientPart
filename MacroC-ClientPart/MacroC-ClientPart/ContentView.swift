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
                    Image(systemName: "music.note.list")
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
        }.onAppear {
            awsService.accesseToken = KeychainItem.currentTokenResponse
            if awsService.isSignUp {
                    awsService.getUserProfile { //유저프로필 가져오기
                        awsService.getFollowingList {}}//팔로우 리스트 가져오기
                    awsService.getAllArtistList{}
            }
            print(awsService.accesseToken)
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    ContentView()
}
