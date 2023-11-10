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
    @State private var selection = 0
    
    //MARK: -2.BODY
    var body: some View {
        ZStack{
            if awsService.user.username == "" {
                backgroundView()
                ProgressView()
            } else {
                TabView(selection: $selection){
                    MainView()
                        .tabItem {
                            Image(systemName: "music.note.list")
                            Text("Main")
                        }  .tag(0)
                    
                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }  .tag(1)
                    
                    ProfileSettingView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }  .tag(2)
                }
                
            }
        }.ignoresSafeArea()
            .onAppear {
                awsService.accesseToken = KeychainItem.currentTokenResponse
                print(awsService.accesseToken)
                print("^^accessToken^^")
                if awsService.isSignUp {
                    awsService.getUserProfile { //유저프로필 가져오기
                        awsService.getFollowingList {}}//팔로우 리스트 가져오기
                    awsService.getAllArtistList {
                        awsService.getMyBuskingList()
                        awsService.getMyArtistBuskingList()
                    }
                }
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            .onChange(of: selection) { nowPage in
                switch nowPage {
                case 0 :
                    print("MainView : \(nowPage)")
                    awsService.getUserProfile{
                        awsService.getFollowingList {}
                    }
                case 1 :
                    print("MapView : \(nowPage)")
                    awsService.getAllArtistList { }
                    awsService.getAllArtistBuskingList{}
                case 2 :
                    print("ProfileSettingView : \(nowPage)")
                    awsService.getUserProfile{}
                default :
                    break
                }
            }
    }
}

//MARK: -3.PREVIEW
#Preview {
    ContentView()
}
