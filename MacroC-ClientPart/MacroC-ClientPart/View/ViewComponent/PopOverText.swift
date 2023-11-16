//
//  PopOverSheet.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct PopOverText: View {
    var text: String = "클립보드에 복사되었습니다"
    var body: some View {
        Text(text)
            .font(.custom14semibold())
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(35), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(35)))
            .background(backgroundView().opacity(0.95))
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6).stroke(lineWidth: UIScreen.getWidth(2)).opacity(0.7)
                    .foregroundStyle(LinearGradient(colors: [.white, .appBlue], startPoint: .topLeading , endPoint: .bottomTrailing))
        }
            .shadow(color: .white.opacity(0.4), radius: UIScreen.getWidth(5))
    }
}
