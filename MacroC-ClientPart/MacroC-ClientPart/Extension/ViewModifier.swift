//
//  ViewModifier.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct dropShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .white.opacity(0.2) ,radius: 20, x: -5,y: -5)
            .shadow(color: .black.opacity(0.2) ,radius: 20, x: 5,y: 5)
    }
}

struct mainpageTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.black)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .background{
                Capsule().stroke(Color.white, lineWidth: 2)}
            .shadow(color: .white.opacity(0.15) ,radius: 10, x: -5,y: -5)
            .shadow(color: .black.opacity(0.35) ,radius: 10, x: 5,y: 5)
    }
}
