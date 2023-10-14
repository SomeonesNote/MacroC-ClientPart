//
//  EditUserAcountView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditUserAcountView: View {
    @EnvironmentObject var userAuth: AppleAuth

    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //로그아웃
                Button {
                    KeychainItem.deleteUserIdentifierFromKeychain() //키체인에서 UserIdentifier 제거
                    userAuth.showLoginView = true //로그인뷰로 돌아가기
                    print("Log Out : delete User Identifier From Keychain")
                } label: {
                        Text("로그아웃") 
                        .font(.custom14bold())
                        .padding(UIScreen.getWidth(20))
                }
                //탈퇴
                Button {
                    KeychainItem.deleteUserIdentifierFromKeychain() //키체인에서 UserIdentifier 제거
                    userAuth.showLoginView = true //로그인뷰로 돌아가기
                    print("탈퇴")
                } label: {
                        Text("탈퇴") 
                        .foregroundStyle(Color(appRed))
                        .font(.custom14bold())
                        .padding(UIScreen.getWidth(20))
                }
            }.padding(.top, UIScreen.getHeight(100))
        }
    }
}

#Preview {
    EditUserAcountView()
}
