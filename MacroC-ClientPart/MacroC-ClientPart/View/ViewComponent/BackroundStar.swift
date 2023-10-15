//
//  BackroundStar.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI


import SwiftUI

struct Star: View {
    let radius: CGFloat
    var color1 = Color(.white)
    var color2 = Color(appIndigo2)
    
    var screenWidth: CGFloat = UIScreen.screenWidth
    var screenHeight: CGFloat = UIScreen.screenHeight
    
    var body: some View {
Circle()
            .foregroundStyle(Color.white)
            .frame(width: radius)
            .mask(RadialGradient(gradient: Gradient(colors: [Color.black,Color.clear, Color.clear]), center: .center,startRadius: 0, endRadius: radius / 2))
            .shadow(color: Color(appIndigo2).opacity(0.7),radius: 5)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .blur(radius: 3)
                    .foregroundColor(Color(appIndigo2).opacity(0.3))
                    .padding(0)
            }
    }
}

struct BackroundStar: View {
    var color1 = Color(.yellow)
    var color2 = Color(.cyan)
    
    var screenWidth: CGFloat = UIScreen.screenWidth
    var screenHeight: CGFloat = UIScreen.screenHeight
    
    let randomOffsetx1 = CGFloat.random(in: 1..<UIScreen.getWidth(390)/3)
    let randomOffsetx2 = CGFloat.random(in: 1..<UIScreen.getWidth(390)/4)
    let randomOffsetx3 = CGFloat.random(in: 1..<UIScreen.getWidth(390)/2)
    let randomOffsetx4 = CGFloat.random(in: 1..<UIScreen.getWidth(390)/5)
    let randomOffsetx5 = CGFloat.random(in: 1..<UIScreen.getWidth(390)/6)
    let randomOffsety1 = CGFloat.random(in: 1..<UIScreen.getHeight(844)/6)
    let randomOffsety2 = CGFloat.random(in: 1..<UIScreen.getHeight(844)/5)
    let randomOffsety3 = CGFloat.random(in: 1..<UIScreen.getHeight(844)/3)
    let randomOffsety4 = CGFloat.random(in: 1..<UIScreen.getHeight(844)/4)
    let randomOffsety5 = CGFloat.random(in: 1..<UIScreen.getHeight(844)/2)
    
    @State private var offsetX: [CGFloat] = [0,0,0,0,0,0,0,0,0,0]
    @State private var offsetY: [CGFloat] = [0,0,0,0,0,0,0,0,0,0]
    @State private var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Star(radius: screenWidth/8 ,color1: color1, color2: color2.opacity(0.1))
                .offset(x:randomOffsetx1, y: -randomOffsety1)
                .offset(x:offsetX[0], y: offsetY[0])
            Star(radius: screenWidth/27 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:-randomOffsetx1, y: randomOffsety2)
                .offset(x:offsetX[1], y: offsetY[1])
            Star(radius: screenWidth/26 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:randomOffsetx2, y: -randomOffsety1)
                .offset(x:offsetX[2], y: offsetY[2])
            Star(radius: screenWidth/25 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:-randomOffsetx2, y: randomOffsety2)
                .offset(x:offsetX[3], y: offsetY[3])
            Star(radius: screenWidth/19 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:-randomOffsetx3, y: randomOffsety3)
                .offset(x:offsetX[4], y: offsetY[4])
            Star(radius: -screenWidth/18 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:randomOffsetx4, y: -randomOffsety3)
                .offset(x:offsetX[5], y: offsetY[5])
            Star(radius: screenWidth/37 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:randomOffsetx4, y: -randomOffsety4)
                .offset(x:offsetX[6], y: offsetY[6])
            Star(radius: screenWidth/36 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:randomOffsetx5, y: -randomOffsety5)
                .offset(x:offsetX[7], y: offsetY[7])
            Star(radius: screenWidth/35 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:-randomOffsetx4, y: randomOffsety4)
                .offset(x:offsetX[8], y: offsetY[8])
            Star(radius: screenWidth/39 ,color1: color1, color2: color2.opacity(0.3))
                .offset(x:-randomOffsetx5, y: randomOffsety5)
                .offset(x:offsetX[9], y: offsetY[9])
        }.opacity(0.9)
        .onReceive(timer) { _ in
            withAnimation(.easeIn(duration: 50)) {
                for i in 0..<offsetX.count {
                    offsetX[i] = Double.random(in: -300...300)
                }
                for i in 0..<offsetY.count {
                    offsetY[i] = Double.random(in: -400...400)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        backgroundView()
        BackroundStar()
    }
}
