//
//  ProfileView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileView: View {
    
    @State var selectedBusking: Busking = dummyBusking1
    @State private var isOn = false
    @State private var isT2 = true
    @State var isShowBuskerProfile: Bool = false
    
    var user: User = dummyUser
    
    var body: some View {
        NavigationView {
            ZStack{
                backgroundStill
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all, edges: .top)
                    VStack {
                    HStack {
                        ProfileCircle(image: user.avartaUrl) //아티스트 정보로 바뀌어야함
                            .padding(.trailing, 30)
                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            Text(user.username) //아티스트 이름으로 바뀌어야함
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 10)
                            HStack{
                                DonationBar()
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                    
                    customDivider()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            NavigationLink("프로필 관리", destination: MainView())
                                .padding(.all, 20)
                            
                            NavigationLink("아티스트 관리", destination: EditBuskerView())
                                .padding(.all, 20)
                            
                            NavigationLink("후원 목록", destination: DonationListView())
                                .padding(.all, 20)
                        }
                        
                        customDivider()
                        
                        Toggle("알림 설정", isOn: $isOn)
                            .padding(.all, 20)
                        
                        customDivider()
                        
                        if isT2 {
//                            NavigationLink("아티스트 계정 전환", destination: ArtistProfileView(isShowBuskerProfile: $isShowBuskerProfile))
//                                .padding(.all, 20)
                            Button(action: {
                                isShowBuskerProfile = true
                            }, label: {
                                Text("아티스트 계정 전환") .padding(.all, 20)
                            })
                        } else {
                            NavigationLink("아티스트 계정 등록", destination: MainView())
                                .padding(.all, 20)
                        }
                        
                        NavigationLink("계정 관리", destination: EditUserAcountView())
                            .padding(.all, 20)
                    }
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $isShowBuskerProfile, content: {
            BuskerProfileView(isShowBuskerProfile: $isShowBuskerProfile)
        })
    }
}


#Preview {
    ProfileView()
}

