//
//  LaunchScreenView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

//import SwiftUI
//
//struct LaunchScreenView: View {
//    var body: some View {
//        ZStack {
//            VStack(spacing: 20) {
//                Image(AppLogo)
//                    .resizable()
//                    .scaledToFit()
//                    .cornerRadius(10)
//                    .frame(width: 100)
//                    .shadow(color: .white.opacity(0.2) ,radius: 10, x: -5,y: -5)
//                    .shadow(color: .black.opacity(0.2) ,radius: 10, x: 5,y: 5)
//                Rectangle()
//                    .foregroundStyle(LinearGradient(colors: [Color.white, Color(appSky).opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .frame(width: 300, height: 70)
//                    .mask {
//                        Text("appName")
//                            .font(.system(size: 50,weight: .heavy))
//                    }
//                    .shadow(color: .white.opacity(0.2) ,radius: 20, x: -5,y: -5)
//                    .shadow(color: .black.opacity(0.2) ,radius: 20, x: 5,y: 5)
//
//            }
//        }
//    }
//}
//
//#Preview {
//    LaunchScreenView()
//}
