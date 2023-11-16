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

struct backgroundViewForMap: View {
    var body: some View {
        ZStack {
            Image("backgroundForMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
