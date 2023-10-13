//
//  ProfileView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ProfileView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = ProfileViewModel()
    
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
        }.fullScreenCover(isPresented: $viewModel.isShowBuskerProfile) {BuskerProfileView()}
    }
}

//MARK: -3.PREVIEW
#Preview {
    ProfileView()
}

//MARK: -4.EXTENSION
extension ProfileView {
    var profileSection: some View {
        HStack(spacing: 20) {
            Image(viewModel.user.userimage)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.getWidth(120), alignment: .center)
                .clipShape(Circle())
                .shadow(color: .white.opacity(0.2),radius: 20)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 3)
                        .blur(radius: 4)
                        .foregroundColor(Color(appSky).opacity(0.6))
                        .padding(0)
                }
            VStack(alignment: .leading) {
                Text(viewModel.user.username)
                    .font(.custom20bold())
                    .padding(.bottom, UIScreen.getWidth(10))
                Text("userIdentifier: \(KeychainItem.currentUserIdentifier)")
                    .font(.custom12bold())
                HStack{
                    DonationBar()
                }
            }
            Spacer()
        }.padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var profileSetting: some View {
        NavigationLink {
            MainView()
        } label: {
            Text("프로필 관리")
                .font(.custom14bold())
                .padding(UIScreen.getWidth(20))
        }
    }
    
    var artistSetting: some View {
        NavigationLink {
            EditFollowingListView()
        } label: {
            Text("아티스트 관리")
                .font(.custom14bold())
                .padding(UIScreen.getWidth(20))
        }
    }
    
    var donationList: some View {
        NavigationLink {
            DonationListView()
        } label: {
            Text("후원 목록")
                .font(.custom14bold())
                .padding(UIScreen.getWidth(20))
        }
    }
    
    var notificationSetting: some View {
        Toggle(isOn: $viewModel.isOn, label: {
            Text("알림 설정")
                .font(.custom14bold())
        }).padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
    }
    
    var artistAccount: some View {
        Group {
            if viewModel.isT2 {
                Button {
                    viewModel.isShowBuskerProfile = true
                } label: {
                    Text("아티스트 계정 전환")
                        .font(.custom14bold())
                        .padding(UIScreen.getWidth(20))
                }
            } else {
                NavigationLink {
                    MainView()
                } label: {
                    Text("아티스트 계정 등록")
                        .font(.custom14bold())
                        .padding(UIScreen.getWidth(20))
                }
            }
        }
    }
    
    var accountSetting: some View {
        NavigationLink {
            EditUserAcountView()
        } label: {
            Text("계정 관리")
                .font(.custom14bold())
                .padding(UIScreen.getWidth(20))
        }
    }
}
