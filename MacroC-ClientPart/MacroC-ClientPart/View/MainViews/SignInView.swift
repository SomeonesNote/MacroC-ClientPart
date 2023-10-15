//
//  SignInView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import SwiftUI

struct SignInView: View {
    
    //MARK: -1.PROPERTY

    //MARK: -2.BODY
    var body: some View {
        VStack(spacing: UIScreen.getWidth(80)) {
//            Image(AppLogo)
//                .resizable()
//                .scaledToFit()
//                .frame(height: UIScreen.getHeight(200))
//                .cornerRadius(30)
            AppleSigninButton().padding()
                .offset(y: UIScreen.getHeight(240))
                .shadow(color: .black.opacity(0.5) ,radius: 8)
        }.background(backgroundView().ignoresSafeArea())
    }
}

//MARK: -3.PREVIEW

#Preview {
    SignInView()
}

//MARK: -4.EXTENSION

