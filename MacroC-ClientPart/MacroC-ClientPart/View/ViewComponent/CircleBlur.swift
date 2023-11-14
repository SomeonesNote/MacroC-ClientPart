//
//  CircleBlur.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct CircleBlur: View {
    //MARK: -1.PROPERTY
    var image: String
    var width: CGFloat = UIScreen.getWidth(105)
    var strokeColor: Color = Color(appIndigo2)
    var shadowColor: Color = Color.black
    var circleImageView: UIImageView? = nil
    
    //MARK: -2.BODY
    var body: some View {
        //        Image(image)
        AsyncImage(url: URL(string: image)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.getWidth(width), height: UIScreen.getHeight(width))
        .clipShape(Circle())
        .mask(RadialGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), center: .center,startRadius: 0, endRadius: width / 2))
        .shadow(color: shadowColor.opacity(0.5),radius: UIScreen.getWidth(8))
        .overlay {
            Circle()
                .stroke(lineWidth: UIScreen.getWidth(2))
                .blur(radius: 3)
                .foregroundColor(strokeColor.opacity(0.6))
                .padding(0)
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    ProfileSettingView()
}
