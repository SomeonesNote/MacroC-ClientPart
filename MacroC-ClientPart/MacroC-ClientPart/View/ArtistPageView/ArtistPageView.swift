//
//  ArtistPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ArtistPageView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @ObservedObject var viewModel : ArtistPageViewModel
    @Environment(\.dismiss) var dismiss
    @State var clickedDdot: Bool = false
    @State var clickedReport: Bool = false
    @State var clickedBlock: Bool = false
    @State var showReport: Bool = false
    @State var isLoading: Bool = false
    
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(5)) {
                    
                    artistPageImage
                        .scrollDisabled(true)
                    artistPageTitle
                    
                    artistPageFollowButton
                    
                    Spacer()
                }
            }.blur(radius: clickedDdot || isLoading ? 15 : 0)
            if clickedDdot {
                VStack(alignment: .leading, spacing: 15) {
                    Button {
                        clickedReport = true
                    } label: {
                        HStack(spacing: 20) {
                            Image(systemName: "light.beacon.min.fill")
                            Text("Report")
                        }
                    }
                    
                    customDivider()
                    
                    Button {
                        clickedBlock = true
                    } label: {
                        HStack(spacing: 20) {
                            Image(systemName: "hand.raised.slash.fill")
                            Text("Block")
                        }
                    }
                }
                .font(.custom18semibold())
                .padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(15)))
                .background(.ultraThickMaterial.opacity(0.7))
                .cornerRadius(6)
                .padding(.horizontal, UIScreen.getWidth(25) )
            }
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(alignment: .center) {
                        ProgressView()
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if clickedDdot {
                        clickedDdot = false
                    } else {
                        clickedDdot = true
                    }
                } label:
                { customSFButton(image: clickedDdot ? "xmark.circle.fill" : "ellipsis.circle.fill").shadow(color: .black.opacity(0.3),radius: UIScreen.getHeight(5))
                }.scaleEffect(0.8)
            }
        }
        
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear{
            viewModel.isfollowing = awsService.followingInt.contains(viewModel.artist.id)
        }
        .sheet(isPresented: $showReport, onDismiss: onDismiss){
            ReportPage(artistID: viewModel.artist.id)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Report", isPresented: $clickedReport) {
            Button(role: .destructive) {
                showReport = true
            } label: {
                Text("Report")
            }
            Button(role: .cancel) { } label: {
                Text("Cancle")
            }
        } message: {
            Text("Are you sure report this artist?")
        }
        .confirmationDialog("Block", isPresented: $clickedBlock) {
            Button(role: .destructive) {
                isLoading = true
                awsService.blockingArtist(artistId: viewModel.artist.id) {
                    isLoading = false
                }
            } label: {
                Text("Block")
            }
            Button(role: .cancel) { } label: {
                Text("Cancle")
            }
        } message: {
            Text("Are you sure block this artist?")
        }
    }
}

//MARK: -4.EXTENSION
extension ArtistPageView {
    var artistPageImage: some View {
        AsyncImage(url: URL(string: viewModel.artist.artistImage)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        .overlay (
            HStack(spacing: UIScreen.getWidth(10)){
                if viewModel.artist.youtubeURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (viewModel.artist.youtubeURL)!)!)
                    } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if viewModel.artist.instagramURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.instagramURL!)!)
                    } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if viewModel.artist.soundcloudURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.instagramURL!)!)
                    } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
            }
                .frame(height: UIScreen.getHeight(25))
                .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
            ,alignment: .bottomTrailing )
    }
    
    var artistPageTitle: some View {
        return VStack{
            Text(viewModel.artist.stageName)
                .font(.custom40black())
                .shadow(color: .black.opacity(1),radius: UIScreen.getWidth(9))
            Text(viewModel.artist.artistInfo)
                .font(.custom13heavy())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var artistPageFollowButton: some View {
        Button {
            isLoading = true
            if awsService.followingInt.contains(viewModel.artist.id) == false {
                awsService.following(userid: awsService.user.id, artistid: viewModel.artist.id) {
                    awsService.getFollowingList(completion: {
                        isLoading = false
                    })
                }
            } else {
                awsService.unFollowing(userid: awsService.user.id, artistid: viewModel.artist.id) {
                    awsService.getFollowingList(completion: { 
                        isLoading = false
                    })
                }
            }
        } label: {
            Text(viewModel.isfollowing ? "Unfollow" : "Follow")
                .font(.custom21black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    func onDismiss() {
        showReport = false
    }
}
