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
            .shadow(color: .white.opacity(0.1) ,radius: 3)
    }
}

