//
//  MainView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct MainView: View{
    
    //MARK: - 1.PROPERTY
    @ObservedObject var viewModel = MainViewModel()
    
    //MARK: - 2.BODY
    var body: some View {
            NavigationView {
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
                    .navigationTitle("")
                    .background(backgroundView())
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
    
    var buskingInfoImage: some View {
        Image(viewModel.user.userimage)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(color: .white.opacity(0.4), radius: 30)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .blur(radius: 1)
                    .foregroundColor(Color(appSky).opacity(0.2))
                    .padding(0)
            }
    }

    var MyProfileSection: some View {
        return VStack {
            HStack{
                roundedBoxText(text: "My Profile")
                Spacer()
                Button { } label: {customSFButton(image: "ellipsis.circle.fill")}
            }.padding(.init(top: 0, leading: 15, bottom: 20, trailing: 15))
            
            HStack(alignment: .top, spacing: 20){
                Image(viewModel.user.userimage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120, alignment: .center)
                    .clipShape(Circle())
                    .shadow(color: .white.opacity(0.4), radius: 3)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 3)
                            .blur(radius: 2)
                            .foregroundColor(Color(appSky).opacity(0.5))
                            .padding(2)
                    }
                    .padding(.leading, 20)
                
                VStack(alignment: .leading) {
                    Text(viewModel.user.username)
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
                    ForEach(dummyUserFollowing) { i in
                        NavigationLink {
                            BuskerPageView(viewModel: BuskerPageViewModel(busker: i))
                        } label: {
                            ProfileRectangle(image: i.artistimage,name: i.stagename)
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
            
            VStack(spacing: 15) {
                ForEach(dummyBuskingNow) { i in
                    BuskingListRow(busking: i)
                        .onTapGesture {
                            viewModel.selectedBusking = i
                            viewModel.isClickedBuskingInfo = true
                        }
                        .sheet(isPresented: $viewModel.isClickedBuskingInfo, onDismiss: {viewModel.isClickedBuskingInfo = false}) {
                            MapBuskingInfoView(viewModel: MapBuskingInfoViewModel(busking: viewModel.selectedBusking))
                                .presentationDetents([.fraction(0.8)])
                                .presentationDragIndicator(.visible)
                    }
                }
            }
        }.padding(.init(top: 0, leading: 4, bottom: 100, trailing: 4))
    }
}
