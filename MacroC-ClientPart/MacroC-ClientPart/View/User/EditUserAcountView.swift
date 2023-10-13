//
//  EditUserAcountView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditUserAcountView: View {
    @EnvironmentObject var userAuth: UserAuth

    var body: some View {
        ZStack(alignment: .center) {
            backgroundView().ignoresSafeArea()
            VStack{
                Button {
                    KeychainItem.deleteUserIdentifierFromKeychain()
                    userAuth.showLoginView = true
                    print("Log Out")
                    print("delete User Identifier From Keychain")
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .font(.custom14bold())
                        Spacer()
                    }
                }
                .padding()
                .frame(width: UIScreen.getWidth(380), height: UIScreen.getHeight(50))
                .background(Color.black)
                .cornerRadius(25)
            }
        }
    }
}

#Preview {
    EditUserAcountView()
}
