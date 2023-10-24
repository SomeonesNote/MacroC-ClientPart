//
//  EditUserAcountView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditUserAcountView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //로그아웃
                Button {
                    KeychainItem.deleteUserIdentifierFromKeychain() //키체인에서 UserIdentifier 제거
                    awsService.isSignIn = false //로그인뷰로 돌아가기
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
                    print("Log Out : delete User Identifier From Keychain")
                } label: {
                    Text("로그아웃")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                //탈퇴
                Button {
                    awsService.isSignIn = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    awsService.deleteUser()
                    try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
                    print("탈퇴")
                } label: {
                    Text("탈퇴")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.padding(.top, UIScreen.getHeight(100))
        }
    }
}

//#Preview {
//    EditUserAcountView(userAuth: aws)
//}
