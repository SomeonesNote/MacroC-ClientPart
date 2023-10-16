//
//  ProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileSettingView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = ProfileSettingViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                profileSection
                
                customDivider()
                profileSetting
                artistSetting
                //                donationList
                
                customDivider()
                notificationSetting
                
                customDivider()
                artistAccount
                accountSetting
                
                
                Spacer()
            }.background(backgroundView().ignoresSafeArea())
                .navigationTitle("")
        }.fullScreenCover(isPresented: $viewModel.popArtistProfile) {ArtistProfileSettingView()}
    }
}

//MARK: -3.PREVIEW
#Preview {
    ProfileSettingView()
}

//MARK: -4.EXTENSION
extension ProfileSettingView {
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: viewModel.user.userimage, width: 120)
            VStack(alignment: .leading) {
                Text(viewModel.user.username)
                    .font(.custom24bold())
                Text(" ")
                    .font(.custom14semibold())
                    .padding(.bottom, UIScreen.getWidth(15))
                HStack{
                    DonationBar()
                }
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }.padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var profileSetting: some View {
        NavigationLink {
            UserPageView(viewModel: UserPageViewModel(user: dummyUser))
        } label: {
            Text("프로필 관리")
                .font(.custom15bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var artistSetting: some View {
        NavigationLink {
            EditFollowingListView()
        } label: {
            Text("아티스트 관리")
                .font(.custom15bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var donationList: some View {
        NavigationLink {
            DonationListView()
        } label: {
            Text("후원 목록")
                .font(.custom15bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var notificationSetting: some View {
        Toggle(isOn: $viewModel.switchNotiToggle, label: {
            Text("알림 설정")
                .font(.custom15bold())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }).padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
            .tint(.cyan.opacity(0.4))
        
    }
    
    var artistAccount: some View {
        Group {
            if viewModel.isArtistAccount {
                Button {
                    viewModel.popArtistProfile = true
                } label: {
                    Text("아티스트 계정 전환")
                        .font(.custom15bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            } else {
                NavigationLink {
                    MainView()
                } label: {
                    Text("아티스트 계정 등록")
                        .font(.custom15bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    
    var accountSetting: some View {
        NavigationLink {
            EditUserAcountView()
        } label: {
            Text("계정 관리")
                .font(.custom15bold())
                .padding(UIScreen.getWidth(20))
        }
    }
}