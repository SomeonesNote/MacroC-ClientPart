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
                Spacer()
                NavigationLink {
                    ArtistListView().toolbarBackground(.hidden, for: .navigationBar)
                } label: {customSFButton(image: "plus.circle.fill")}

            } .padding(.init(top: UIScreen.getWidth(60), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(20)))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(dummyUserFollowing) { i in
                        NavigationLink {
                            ArtistPageView(viewModel: ArtistPageViewModel(busker: i))
                        } label: {
                            ProfileRectangle(image: i.artistimage,name: i.stagename)
                        }
                    }
                }
            }
        }.padding(.vertical, UIScreen.getWidth(40))
    }
    
    var BuskingInfoSection: some View {
        return VStack {
            HStack {
                roundedBoxText(text: "Busking Info")
                Spacer()
            }.padding(UIScreen.getWidth(20))
            
            VStack(spacing: UIScreen.getWidth(15)) {
                ForEach(dummyBuskingNow) { i in
                    BuskingListRow(busking: i)
                        .onTapGesture {
                            viewModel.selectedBusking = i
                            viewModel.isClickedBuskingInfo = true
                        }
                        .sheet(isPresented: $viewModel.isClickedBuskingInfo, onDismiss: {viewModel.isClickedBuskingInfo = false}) {
                            MapBuskingInfoView(viewModel: MapBuskingInfoViewModel(busking: viewModel.selectedBusking))
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)                    }
                }
            }
        }
        .padding(.init(top: 0, leading: UIScreen.getWidth(5), bottom:  UIScreen.getWidth(120), trailing:  UIScreen.getWidth(5)))
    }
}
