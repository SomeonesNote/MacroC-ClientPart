//
//  BuskerPageView.swift
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
                
                buskerPageImage
                    .scrollDisabled(true)
                buskerPageTitle
                
                buskerPageFollowButton
                
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
    ArtistPageView(viewModel: ArtistPageViewModel(busker: dummyArtist4))
}

//MARK: -4.EXTENSION
extension ArtistPageView {
    var buskerPageImage: some View {
        Image(viewModel.artist.artistimage)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: UIScreen.getWidth(10)){
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.youtube)!)
                    } label: { linkButton(name: YouTubeLogo) }
                    
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.artist.instagram)!)
                    } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                    
                }
                    .frame(height: UIScreen.getHeight(25))
                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
                ,alignment: .bottomTrailing )}
    
    var buskerPageTitle: some View {
        return VStack{
            Text(viewModel.artist.stagename)
                .font(.custom44black())
            
            Text("Simple Imforamtion of This Artist")
                .font(.custom14heavy())
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var buskerPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.custom24black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
        }
    }
}
