//
//  ArtistProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ArtistProfileSettingView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = UserArtistProfileSettingViewModel()
    @Environment(\.dismiss) var dismiss
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                profileSection
                
                customDivider()
                
                firstSection
                
                customDivider()
                
                secondSection
                
                customDivider()
                
                thirdSection
                
                Spacer()
            }
            .background(backgroundView().ignoresSafeArea())
            .overlay(alignment: .topLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.custom18bold())
                        .padding(.init(top: UIScreen.getWidth(0), leading: UIScreen.getWidth(25), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(0)))
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $viewModel.popAddBusking, content: {
                AddBuskingPageView(viewModel: AddBuskingPageViewModel())
            })
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    ArtistProfileSettingView()
}

//MARK: -4.EXTENSION

extension ArtistProfileSettingView {
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: viewModel.userArtist.artistimage, width: 120)
            
            VStack(alignment: .leading) {
                Text(viewModel.userArtist.stagename)
                    .font(.custom24bold())
                Text(viewModel.userArtist.artistinfo)
                    .font(.custom14semibold())
                    .padding(.bottom, UIScreen.getWidth(15))
                HStack{
                    DonationBar()
                }
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }
        .padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var firstSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                UserArtistPageView(viewModel: UserArtistPageViewModel(userArtist: dummyUserArtist))
            } label: {
                Text("아티스트 페이지 관리")
                    .font(.custom15bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            Button {
                viewModel.popAddBusking = true
            } label: {
                Text("공연 등록")
                    .font(.custom15bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            //            NavigationLink {
            //                EditFanView()
            //            } label: {
            //                Text("팬 관리")
            //                    .font(.custom15bold())
            //                    .padding(UIScreen.getWidth(20))
            //                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            //            }
            //            NavigationLink {
            //                EditDonationView()
            //            } label: {
            //                Text("후원 관리")
            //                    .font(.custom14bold())
            //                    .padding(UIScreen.getWidth(20))
            //            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            //            }
            //
        }
    }
    
    
    var secondSection: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $viewModel.switchNotiToggle, label: {
                Text("알림 설정")
                    .font(.custom15bold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                
            })
        }.padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
    }
    
    
    var thirdSection: some View {
        VStack(alignment: .leading) {
            Button{
                dismiss()
            } label: {
                Text("개인 계정 전환")
                    .font(.custom15bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            NavigationLink {
                EditArtistAcountView()
            } label: {
                Text("아티스트 계정 관리")
                    .font(.custom15bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }
    }
}

