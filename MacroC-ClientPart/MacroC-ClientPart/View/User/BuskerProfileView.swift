//
//  BuskerProfileView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct BuskerProfileView: View {
    
    @State var selectedBusking: Busking = dummyBusking1
    @State private var isOn = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    @Binding var isShowBuskerProfile: Bool
    @State var isShowAddBusking: Bool = false
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
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .padding(.horizontal)
                        })
                        Spacer()
                    }.padding(.top, 60)
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
                    
                    
                    customDivider()
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            NavigationLink("아티스트 페이지 관리", destination: UserBuskerPageView(viewModel: UserBuskerPageViewModel(userBusker: dummyUserBusker)))
                                .navigationTitle("")
                                .padding(.all, 20)
                            
                            
                            Button(action: {
                                isShowAddBusking = true
                            }, label: {
                                Text("공연 등록")
                                    .padding(.all, 20)
                            })
                            
                            NavigationLink("팬 관리", destination: EditFanView())
                                .padding(.all, 20)
                            
                            NavigationLink("후원 관리", destination: EditDonationView())
                                .padding(.all, 20)
                        }
                        
                        customDivider()
                        
                        Toggle("알림 설정", isOn: $isOn)
                            .padding(.all, 20)
                        
                        customDivider()
                        
                        Button("개인 계정 전환", action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                            .padding(.all, 20)
                        
                        NavigationLink("아티스트 계정 관리", destination: EditBuskerAcountView())
                            .padding(.all, 20)
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isShowAddBusking, content: {
            AddBuskingPageView(viewModel: AddBuskingPageViewModel())
        })
    }
}

#Preview {
    BuskerProfileView(isShowBuskerProfile: .constant(true))
}

