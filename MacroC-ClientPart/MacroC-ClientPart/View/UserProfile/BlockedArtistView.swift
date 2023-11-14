//
//  BlockedArtistView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/11/12.
//

import SwiftUI

struct BlockedArtistView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @ObservedObject var viewModel : BlockedArtistViewModel
    @Environment(\.dismiss) var dismiss
    @State var clickedUnBlock: Bool = false
    @State var isLoading: Bool = false
    
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(5)) {
                    artistPageImage
                        .scrollDisabled(true)
                    artistPageTitle
                    
                    Spacer()
                }
            }.blur(radius: isLoading ? 15 : 0)
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
                    clickedUnBlock = true
                } label: {
                toolbarButtonLabel(buttonLabel: "Unblock")
            }
        }
    }
    
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear{
            viewModel.isfollowing = awsService.followingInt.contains(viewModel.artist.id)
        }
        .confirmationDialog("Unblock", isPresented: $clickedUnBlock) {
            Button(role: .destructive) {
                isLoading = true
                awsService.unblockingArtist(artistId: viewModel.artist.id) {
                    isLoading = false
                    dismiss()
                }
            } label: {
                Text("Unblock")
            }
            Button(role: .cancel) { } label: {
                Text("Cancle")
            }
        } message: {
            Text("Are you sure unblock this artist?")
        }
}
}

//MARK: -4.EXTENSION
extension BlockedArtistView {
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
}
