//
//  BackgroundView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct backgroundView: View {
    var body: some View {
        ZStack {
            backgroundStill
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
#Preview {
    backgroundView()
}
