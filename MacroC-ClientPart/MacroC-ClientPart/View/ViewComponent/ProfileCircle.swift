//
//  ProfileCircle.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileCircle: View {
    //MARK: -1.PROPERTY
    var image: String = ""
    
    //MARK: -2.BODY

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 140, height: 140)
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .padding(5)
            .modifier(dropShadow())
        
    }
}

    //MARK: -3.PREVIEW
#Preview {
    ProfileCircle()
}
