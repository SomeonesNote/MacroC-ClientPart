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
//            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .padding(-10)
            .overlay {
                Circle()
                    .stroke(lineWidth: 1)
                    .blur(radius: 3)
                    .foregroundColor(Color(appBlue).opacity(0.3))
                    .padding(1)
            }

    }
}

    //MARK: -3.PREVIEW
#Preview {
    ProfileCircle()
}
