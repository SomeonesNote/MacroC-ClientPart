//
//  ProfileRectangle.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileRectangle: View {
    
    //MARK: -1.PROPERTY
    var image: String = ""
    var name: String = ""
    
    //MARK: -2.BODY
    var body: some View {
        VStack(spacing: 2){
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.getWidth(140), height: UIScreen.getHeight(140))
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,  Color.clear]), startPoint: .top, endPoint: .bottom))
            Text(name)
                .font(.custom14black())
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appIndigo1), Color(appIndigo2), Color(appIndigo1)], startPoint: .topTrailing, endPoint: .bottomLeading)).opacity(0.4))
        .frame(width: UIScreen.getWidth(140), height: UIScreen.getHeight(160))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(UIScreen.getWidth(8))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: 1)
                .blur(radius: 2)
                .foregroundColor(Color(appBlue).opacity(0.2))
                .padding(UIScreen.getWidth(8))
        }
    }
}

//MARK: -1.PREVIEW
#Preview {
    MainView()
}
