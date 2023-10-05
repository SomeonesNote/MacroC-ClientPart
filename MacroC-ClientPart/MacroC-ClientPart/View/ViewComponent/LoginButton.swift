//
//  LoginButton.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct LogInButton: View {
    //MARK: -1.PROPERTY
    var LogoName: String = "KakaoLogo"
    var ButtonText: String = "Kakao로 로그인하기"
    
    //MARK: -2.BODY
    var body: some View {
        HStack {
            Image(LogoName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .padding(.horizontal,30)
            
            Spacer()
            
            Text(ButtonText)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .font(.subheadline)
            
            Spacer()
            Spacer()
        }
        
        .padding(.vertical, 10)
        .background(backgroundGradient(a: Color(appBlue), b: Color(appIndigo1)).opacity(0.7))
        .cornerRadius(25)
        .mask{
            ZStack {
                Capsule().stroke(Color.black, lineWidth: 5)
                Capsule().padding(3)
            }
        }
        
    }
}

//MARK: -3.PREVIEW
#Preview {
    LogInButton()
}
