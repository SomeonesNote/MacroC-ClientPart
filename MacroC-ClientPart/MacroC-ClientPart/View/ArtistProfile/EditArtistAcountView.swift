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
    @Binding var onDismiss: Bool
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //탈퇴
                Button {
                    showDeleteAlert = true
                } label: {
                    Text("아티스트 계정 탈퇴")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                Spacer()
            }.padding(.top, UIScreen.getHeight(100))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text(""), message: Text("Are you sure you want to delete your account?"), primaryButton: .destructive(Text("Delete"), action: {
                        print("탈퇴 완료")
                        awsService.deleteUserArtist()
                        showDeleteAlert = false
                        onDismiss = false
                    }), secondaryButton: .cancel(Text("Cancle")))
                }
        }
    }
}

//MARK: -3.PREVIEW
//#Preview {
//    EditArtistAcountView()
//}
