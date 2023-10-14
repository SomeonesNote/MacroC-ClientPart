//
//  BuskerProfileView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ArtistProfileView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel = ArtistProfileViewModel()
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
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $viewModel.isShowAddBusking, content: {
                AddBuskingPageView(viewModel: AddBuskingPageViewModel())
        })
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    ArtistProfileView()
}

//MARK: -4.EXTENSION

extension ArtistProfileView {
    var profileSection: some View {
        HStack(spacing: 20) {
            CircleBlur(image: viewModel.user.userimage, width: 120)
            
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
        }
        .padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var firstSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                UserArtistPageView(viewModel: UserArtistPageViewModel(userArtist: dummyArtist2))
            } label: {
                Text("아티스트 페이지 관리")
                    .font(.custom14bold())
                    .padding(UIScreen.getWidth(20))
            }
            Button {
                viewModel.isShowAddBusking = true
            } label: {
                Text("공연 등록")
                    .font(.custom14bold())
                    .padding(UIScreen.getWidth(20))
            }
            NavigationLink {
                EditFanView()
            } label: {
                Text("팬 관리")
                    .font(.custom14bold())
                    .padding(UIScreen.getWidth(20))
            }
//            NavigationLink {
//                EditDonationView()
//            } label: {
//                Text("후원 관리")
//                    .font(.custom14bold())
//                    .padding(UIScreen.getWidth(20))
//            }
//
        }
    }
    
    
    var secondSection: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $viewModel.isOn, label: {
                Text("알림 설정")
                    .font(.custom14bold())
                
            })
        }.padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
    }
    
    
    var thirdSection: some View {
        VStack(alignment: .leading) {
            Button{
                dismiss()
            } label: {
                Text("개인 계정 전환")
                    .font(.custom14bold())
                    .padding(UIScreen.getWidth(20))
            }
            
            NavigationLink {
                EditBuskerAcountView()
            } label: {
                Text("아티스트 계정 관리")
                    .font(.custom14bold())
                    .padding(UIScreen.getWidth(20))
            }
        }
    }
}

