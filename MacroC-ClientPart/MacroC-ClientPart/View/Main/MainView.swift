//
//  MainView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct MainView: View{
    
    //MARK: - 1.PROPERTY
    @State var isClickedBuskingInfo: Bool = false
    @State var selectedBusking: Busking = dummyBusking1
    var user : User = dummyUser
    
    
    //MARK: - 2.BODY
    var body: some View {
        GeometryReader { Geo in
            NavigationView {
                ZStack {
                    backgroundView()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20){
                            MyProfileSection
                            
                            customDivider()
                            
                            MyartistSection
                            
                            customDivider()
                            
                            BuskingInfoSection
                        }
                    }
                    .padding(.top, 30)
                }
                
                .navigationTitle("")
            }
            .ignoresSafeArea(.all)
        }
    }
}
//MARK: - 3.PREVIEW
#Preview {
    MainView()
}

//MARK: - 4.EXTENSION
extension MainView {
    
    var MyProfileSection: some View {
        return VStack {
            HStack{
                roundedBoxText(text: "My Profile")
                Spacer()
                                Button { } label: {customSFButton(image: "ellipsis.circle.fill")}
            }.padding(.init(top: 0, leading: 15, bottom: 20, trailing: 15))
            
            HStack(alignment: .top, spacing: 20){
                ProfileCircle(image: user.avartaUrl)
                    .padding(.leading, 20)

                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
        }.padding(.init(top: 60, leading: 0, bottom: 10, trailing: 0))
    }
    
    var MyartistSection: some View {
        return VStack {
            HStack {
                roundedBoxText(text: "My Artist")
                Spacer()
                Button { } label: {customSFButton(image: "plus.circle.fill")}
            }.padding(.init(top: 0, leading: 15, bottom: 10, trailing: 15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    //                    ForEach(user.following) { i in // 유저모델에서 일단 팔로잉 지워벌이
                    ForEach(dummyUserFollowing) { i in
                        NavigationLink {
                            BuskerPageView(viewModel: BuskerPageViewModel(busker: i))
                        } label: {
                            ProfileRectangle(image: i.image,name: i.name)
                        }
                    }
                }
                .padding(.bottom,20)
            }
        }
    }
    
    var BuskingInfoSection: some View {
        return VStack {
            HStack {
                roundedBoxText(text: "Busking Info")
                Spacer()
            }.padding(.init(top: 0, leading: 15, bottom: 20, trailing: 15))
            
            VStack(spacing: 5) {
                ForEach(dummyBuskingNow) { i in
                    BuskingListRow(busking: i)
                        .onTapGesture {
                            selectedBusking = i
                            isClickedBuskingInfo = true
                        }
                        .sheet(isPresented: $isClickedBuskingInfo) {
                            MapBuskingInfoView(viewModel: MapBuskingInfoViewModel(busking: selectedBusking))
                                .presentationDetents([.height(uiheight * 3/4)])
                        }
                }
            }
        }.padding(.init(top: 0, leading: 4, bottom: 80, trailing: 4))
    }
}
