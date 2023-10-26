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
    @ObservedObject var viewModel: ArtistPageViewModel
    @State var isfollowing: Bool = false
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UIScreen.getWidth(5)) {
                
                artistPageImage
                    .scrollDisabled(true)
                artistPageTitle
                
                artistPageFollowButton
                
                Spacer()
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear{
            isfollowing = awsService.followingInt.contains(viewModel.artist.id)
        }
    }
}

//MARK: -4.EXTENSION
extension ArtistPageView {
    var artistPageImage: some View {
        //        Image(viewModel.artist.artistImage)
        AsyncImage(url: URL(string: viewModel.artist.artistImage)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        //            .overlay (
        //                HStack(spacing: UIScreen.getWidth(10)){
        //                    Button {
        //                        UIApplication.shared.open(URL(string: viewModel.artist.youtube)!)
        //                    } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
        //
        //                    Button {
        //                        UIApplication.shared.open(URL(string: viewModel.artist.instagram)!)
        //                    } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
        //
        //                    Button { } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
        //                }
        //                    .frame(height: UIScreen.getHeight(25))
        //                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
        //                ,alignment: .bottomTrailing )
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
            if awsService.followingInt.contains(viewModel.artist.id) == false {
                awsService.following(userid: awsService.user.id, artistid: viewModel.artist.id) { // 팔로우하는 함수
                    awsService.getFollowingList(completion: { })
                }
            } else {
                awsService.unFollowing(userid: awsService.user.id, artistid: viewModel.artist.id) { // 언팔하는 함수
                    awsService.getFollowingList(completion: { })
                }
            }
        } label: {
            Text(isfollowing ? "Unfollow" : "Follow")
                .font(.custom21black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
}
