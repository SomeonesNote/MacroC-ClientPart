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
            Spacer()
            
            Text(name)
                .font(.headline)
                .fontWeight(.heavy)
            
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), startPoint: .bottom, endPoint: .top))
            
            
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appBlue), Color(appIndigo1), Color(appIndigo1), Color(appIndigo1), Color(appIndigo1), Color(appIndigo1)], startPoint: .top, endPoint: .bottom)).opacity(0.4))
        .frame(width: 140, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .modifier(dropShadow())
        .padding(8)
        
        
        
    }
}

//MARK: -1.PREVIEW
#Preview {
    MainView()
}
