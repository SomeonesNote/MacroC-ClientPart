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
            Button(action: {
                
            }, label: {
                Image(systemName: "tree")
                Text("2000")

            })
            .padding()
            .background(Capsule().strokeBorder())
        }
    }
}

//MARK: -2.PREVIEW
#Preview {
    DonationBar()
}
