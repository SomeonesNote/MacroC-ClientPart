//
//  TestLoginView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/08.
//

import SwiftUI

struct TestAddBuskerAcountView: View {
    //MARK: -1.PROPERTY
    @StateObject var testbusker = TestBusker()
    
    //MARK: -2.BODY
    var body: some View {
        
        ZStack {
//                            loginBackgroundView()
            VStack(alignment: .center) {
                
                TextField("Name", text: $testbusker.name)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Image", text: $testbusker.image)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Youtube", text: $testbusker.youtube)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("Instagram", text: $testbusker.instagam)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("SoundCloud", text: $testbusker.soundcloud)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                TextField("BuskerInfo", text: $testbusker.buskerInfo)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                HStack {
//                    Button {
//                        sendGetUserProfile(for: self.testuser)
//                    } label: {
//                        Text("Log In")
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(10)
//                    }
                    
                    Button (action : {
                        sendPostBuskerProfile(testBuserProfile: TestBuskerProfile(name: testbusker.name, image: testbusker.image, youtube: testbusker.youtube, instagram: testbusker.instagam, soundcloud: testbusker.soundcloud, buskerInfo: testbusker.buskerInfo))
                    }, label: {
                        Text("Sign In")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    })
                }
            }
            .padding(.init(top: 10, leading: 10, bottom: 50, trailing: 10))
        }
    }
}


//MARK: -3.PREVIEW
#Preview {
    TestAddBuskerAcountView()
}

//MARK: -4.EXTENSION
