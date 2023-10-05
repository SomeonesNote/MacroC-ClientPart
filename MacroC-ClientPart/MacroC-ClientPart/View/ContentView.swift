//
//  ContentView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Main Page")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("My Profile")
                }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }// 탭이 이동할 때 탭바의 백그라운드가 씹히는 것을 막는 위해 추가
    }
}

#Preview {
    ContentView()
}
