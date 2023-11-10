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
    @ObservedObject var viewModel = LoginViewModel()
    @State var showDeleteAlert: Bool = false
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                Button {
                    KeychainItem.deleteUserIdentifierFromKeychain()
                    awsService.isSignIn = false
                    awsService.isSignUp = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
                    
                } label: {
                    Text("로그아웃")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }

                Button {
                   showDeleteAlert = true
                } label: {
                    Text("탈퇴")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.padding(.top, UIScreen.getHeight(100))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text(""), message: Text("Are you sure you want to delete your account?"), primaryButton: .destructive(Text("Delete"), action: {
                        viewModel.deleteAccount()
                        let clientToken = KeychainItem.currentTokenResponse
                        let token = KeychainItem.currentAuthorizationCode
                        viewModel.revokeAppleToken(refreshToken: KeychainItem.currentRefreshToken) {
                            print("appleRevokeIsSuccess")
                        }
                        
                        awsService.deleteUser()
                        showDeleteAlert = false
                        KeychainItem.deleteUserIdentifierFromKeychain()
                        awsService.isSignIn = false
                        awsService.isSignUp = false
                        awsService.isCreatUserArtist = false
                        UserDefaults.standard.set(false, forKey: "isSignIn")
                        UserDefaults.standard.set(false, forKey: "isSignup")
                        UserDefaults.standard.set(false ,forKey: "isCreatUserArtist")
                        try? KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
                    }), secondaryButton: .cancel(Text("Cancle")))
                }
        }
    }
}
