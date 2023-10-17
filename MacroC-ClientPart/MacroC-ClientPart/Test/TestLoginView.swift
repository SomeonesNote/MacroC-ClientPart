//
//  TestLoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/08.
//

import SwiftUI

struct TestLoginView: View {
    //MARK: -1.PROPERTY
    @StateObject var testuser = TestUser()
    
    //MARK: -2.BODY
    var body: some View {
        
        ZStack {
            //                loginBackgroundView()
            VStack(alignment: .center) {
                
                TextField("Email", text: $testuser.email)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Password", text: $testuser.password)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Username", text: $testuser.username)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("AvartaUrl", text: $testuser.avartaUrl)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                HStack {
                    Button {
                        sendGetUserProfile(for: self.testuser)
                    } label: {
                        Text("Log In")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        sendPostRequest(testUserProfile: TestUserProfile(email: testuser.email, username: testuser.username, password: testuser.password, avartaUrl: testuser.avartaUrl))
                    } label: {
                        Text("Sign In")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.init(top: 10, leading: 10, bottom: 50, trailing: 10))
        }
    }
}


//MARK: -3.PREVIEW
#Preview {
    TestLoginView()
}

//MARK: -4.EXTENSION
extension TestLoginView {
    
    
}
