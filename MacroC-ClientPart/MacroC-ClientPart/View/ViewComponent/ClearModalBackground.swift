//
//  ClearModalBackground.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct ClearModalBackground: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }
        func updateUIView(_ uiView: UIView, context: Context) {}
    }


#Preview {
    ClearModalBackground()
}
