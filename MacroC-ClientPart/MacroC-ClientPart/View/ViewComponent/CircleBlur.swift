//
//  CircleBlur.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct CircleBlur: View {
    var image: String 
    var width: CGFloat = 100
    var strokeColor: Color = Color(appIndigo)
    var shadowColor: Color = Color.white
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: UIScreen.getWidth(width))
            .mask(RadialGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), center: .center,startRadius: 0, endRadius: width / 2))
            .shadow(color: shadowColor.opacity(0.4),radius: 2)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .blur(radius: 3)
                    .foregroundColor(strokeColor.opacity(0.6))
                    .padding(0)
            }
    }
}

#Preview {
    ProfileView()
}
