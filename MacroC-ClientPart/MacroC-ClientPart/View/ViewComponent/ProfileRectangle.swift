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
        VStack(spacing: 0){
//            Image(image)
            AsyncImage(url: URL(string: image)){ image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
                .frame(width: UIScreen.getWidth(130), height: UIScreen.getHeight(130))
                .mask(LinearGradient(gradient: Gradient(colors: [Color.clear,Color.clear,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,  Color.clear]), startPoint: .top, endPoint: .bottom))
                .mask(LinearGradient(gradient: Gradient(colors: [Color.clear,Color.gray,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.gray,  Color.clear]), startPoint: .leading, endPoint: .trailing))
                .mask(LinearGradient(gradient: Gradient(colors: [Color.clear,Color.clear,Color.gray,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .mask(LinearGradient(gradient: Gradient(colors: [Color.clear,Color.clear,Color.gray,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), startPoint: .topTrailing, endPoint: .bottomLeading))
            Text(name)
                .font(.custom13black())
                .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appIndigo1), Color(appIndigo2), Color(appIndigo1)], startPoint: .topTrailing, endPoint: .bottomLeading)).opacity(0.1))
        .frame(width: UIScreen.getWidth(130), height: UIScreen.getHeight(145))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(UIScreen.getWidth(8))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: UIScreen.getWidth(2))
                .blur(radius: 2)
                .foregroundColor(Color.white.opacity(0.1))
                .padding(UIScreen.getWidth(8))
        }
    }
}

//MARK: -1.PREVIEW
#Preview {
    MainView()
}
