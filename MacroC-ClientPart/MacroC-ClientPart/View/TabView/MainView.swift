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
    var following: [Artist] = dummyUserFollowing
    var nowBusking: [Busking] = dummyBuskingNow
//    var following: [Artist] = dummyEmptyFollowing
//    var nowBusking: [Busking] = dummyBuskingEmpty
    
    //MARK: - 2.BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(20)){
                    MyartistSection
                    BuskingInfoSection
                }
            }
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
    
    var MyartistSection: some View {
        return VStack {
            HStack {
                roundedBoxText(text: "My Artist")
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                Spacer()
                NavigationLink {
                    ArtistListView().toolbarBackground(.hidden, for: .navigationBar)
                } label: {customSFButton(image: "plus.circle.fill").shadow(color: .black.opacity(0.8),radius: UIScreen.getHeight(5)) }
                
            } .padding(.init(top: UIScreen.getWidth(60), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(20)))
            if following.isEmpty {
                myArtistSkeleton
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(following) { i in
                            NavigationLink {
                                ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                            } label: {
                                ProfileRectangle(image: i.artistimage,name: i.stagename)
                            }
                        }
                    }
                }
            }
        }.padding(.vertical, UIScreen.getWidth(40))
    }
    
    var myArtistSkeleton: some View {
        HStack(alignment: .center, spacing: UIScreen.getWidth(8)) {
            Spacer()
            Image(systemName: "plus.circle.fill").font(.custom20semibold())
            Text("버튼을 눌러 아티스트를 팔로우 해보세요!")
                .font(.custom13bold())
                .fontWidth(.expanded)
            Spacer()
        }.shadow(color: .black.opacity(0.2),radius: UIScreen.getHeight(5))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(height: UIScreen.getHeight(160))
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: UIScreen.getWidth(1))
                    .blur(radius: 2)
                    .foregroundColor(Color.white.opacity(0.1))
                    .padding(0)
            }
            .padding(.horizontal, UIScreen.getHeight(5))
    }
    
    var BuskingInfoSection: some View {
        return VStack {
            HStack {
                roundedBoxText(text: "Busking Info")
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                Spacer()
            }.padding(UIScreen.getWidth(20))
            
            VStack(spacing: UIScreen.getWidth(15)) {
                if nowBusking.isEmpty {
                    HStack(alignment: .center, spacing: UIScreen.getWidth(8)) {
                        Spacer()
                        Image(systemName: "plus.circle.fill").font(.custom20semibold())
                        Text("지금은 공연이 예정된 아티스트가 없어요!")
                            .font(.custom13bold())
                            .fontWidth(.expanded)
                        Spacer()
                    }.shadow(color: .black.opacity(0.2),radius: UIScreen.getHeight(5))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(height: UIScreen.getHeight(160))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(lineWidth: UIScreen.getWidth(1))
                                .blur(radius: 2)
                                .foregroundColor(Color.white.opacity(0.1))
                                .padding(0)
                        }
                } else {
                    ForEach(nowBusking) { i in
                        BuskingListRow(busking: i)
                            .onTapGesture {
                                viewModel.selectedBusking = i
                                viewModel.popBuskingModal = true
                            }
                            .sheet(isPresented: $viewModel.popBuskingModal, onDismiss: {viewModel.popBuskingModal = false}) {
                                MapBuskingModalView(viewModel: MapBuskingModalViewModel(busking: viewModel.selectedBusking))
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                            }
                    }
                }
            }
        }
        .padding(.init(top: 0, leading: UIScreen.getWidth(5), bottom:  UIScreen.getWidth(120), trailing:  UIScreen.getWidth(5)))
    }
}
