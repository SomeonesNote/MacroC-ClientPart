//
//  ArtistPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ArtistPageView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: ArtistPageViewModel
    
    //MARK: -2.BODY
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
                
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
    }
}

//MARK: -3.PREVIEW
#Preview {
    ArtistPageView(viewModel: ArtistPageViewModel(artist: dummyArtist2))
}

//MARK: -4.EXTENSION
extension ArtistPageView {
    var artistPageImage: some View {
        Image(viewModel.artist.artistimage)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: UIScreen.getWidth(10)){
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.youtube)!)
                    } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: 5) }
                    
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.instagram)!)
                    } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: 5) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: 5) }
                    
                }
                    .frame(height: UIScreen.getHeight(25))
                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
                ,alignment: .bottomTrailing )}
    
    var artistPageTitle: some View {
        return VStack{
            Text(viewModel.artist.stagename)
                .font(.custom44black())
                .shadow(color: .black.opacity(1),radius: 9)
            
            Text("Simple Imforamtion of This Artist")
                .font(.custom14heavy())
                .shadow(color: .black.opacity(0.7),radius: 5)
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var artistPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.custom24black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
                .shadow(color: .black.opacity(0.7),radius: 5)
        }
    }
}
