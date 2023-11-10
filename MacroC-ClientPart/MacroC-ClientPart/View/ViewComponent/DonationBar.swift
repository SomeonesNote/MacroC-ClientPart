//
//  DonationBar.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct DonationBar: View {
    
    //MARK: -1.BODY
    var body: some View {
        HStack {
            Button {
                
            } label: {
                HStack(spacing: UIScreen.getWidth(5)){
                    Image(systemName: "tree").font(.custom14regular())
                    Text("2000").font(.custom14semibold())
                }
            }
            .padding(.init(top: UIScreen.getWidth(5), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(5), trailing: UIScreen.getWidth(10)))
            .background(Capsule().stroke(lineWidth: UIScreen.getWidth(1.2)))
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
        }
    }
}


