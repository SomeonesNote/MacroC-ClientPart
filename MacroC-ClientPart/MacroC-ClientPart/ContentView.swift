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
                if awsService.isSignUp {
                    awsService.getUserProfile {
                        awsService.getFollowingList {}}
                    awsService.getAllArtistList { }
                    awsService.getMyBuskingList()
                    awsService.getMyArtistBuskingList()
                }
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            .onChange(of: selection) { nowPage in
                switch nowPage {
                case 0 :
                    awsService.getUserProfile{
                        awsService.getFollowingList {}
                        awsService.getAllArtistList { }
                    }
                case 1 :
                    awsService.getAllArtistList { }
                    awsService.getAllArtistBuskingList{ }
                case 2 :
                    awsService.getUserProfile{}
                default :
                    break
                }
            }
    }
}
