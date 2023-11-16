//
//  ProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileSettingView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @StateObject var viewModel = ProfileSettingViewModel()
    
    
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                profileSection
                
                customDivider()
                profileSetting
                artistSetting
                blockartistSetting
                
                customDivider()
                artistAccount
                accountSetting
                
                
                Spacer()
            }.background(backgroundView().ignoresSafeArea())
                .navigationTitle("")
        }
        .fullScreenCover(isPresented: $viewModel.popArtistProfile) {ArtistProfileSettingView(onDismiss: $viewModel.popArtistProfile)}
        .fullScreenCover(isPresented: $viewModel.popArtistRegisterPage, onDismiss: onDismiss) { RegisterUserArtistView() }
    }
}

//MARK: -4.EXTENSION
extension ProfileSettingView {
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: awsService.user.avatarUrl, width: 120)
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "person.circle.fill").font(.custom18semibold())
                    Text(awsService.user.username).font(.custom21black())
                }
                .padding(.bottom, UIScreen.getWidth(15))
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }.padding(.init(top: UIScreen.getWidth(30), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var profileSetting: some View {
        NavigationLink {
            UserPageView()
        } label: {
            Text("프로필 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var artistSetting: some View {
        NavigationLink {
            EditFollowingListView() 
        } label: {
            Text("아티스트 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var notificationSetting: some View {
        Toggle(isOn: $viewModel.switchNotiToggle, label: {
            Text("알림 설정")
                .font(.custom13bold())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }).padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
            .tint(.cyan.opacity(0.2))
        
    }
    
    var artistAccount: some View {
        VStack(spacing: 0) {
            if  awsService.user.artist?.id ?? 0 > 0 {
                Button {
                    viewModel.popArtistProfile = true
                } label: {
                    Text("아티스트 계정 전환")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            } else {
                Button {
                    viewModel.popArtistRegisterPage = true
                } label: {
                    Text("아티스트 계정 등록")
                        .font(.custom13bold())
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
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
        }
    }
    
    var blockartistSetting: some View {
        NavigationLink {
            EditBlockListView()
        } label: {
            Text("차단 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    func onDismiss() {
        viewModel.popArtistRegisterPage = false
    }
}
