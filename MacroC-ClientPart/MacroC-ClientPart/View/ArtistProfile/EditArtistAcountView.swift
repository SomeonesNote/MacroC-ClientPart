//
//  EditArtistAcountView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditArtistAcountView: View {
        //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @State var showDeleteAlert: Bool = false
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //탈퇴
                Button {
//                    try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
//                    awsService.isSignIn = false //로그인뷰로 돌아가기
                    print("탈퇴")
                } label: {
                    Text("아티스트 계정 탈퇴")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.padding(.top, UIScreen.getHeight(100))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text(""), message: Text("Are you sure you want to delete your account?"), primaryButton: .destructive(Text("Delete"), action: {
//                        awsService.deleteUser() //
                        print("탈퇴 완료")
                        showDeleteAlert = true
                    }), secondaryButton: .cancel(Text("Cancle")))
                }
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    EditArtistAcountView()
}
