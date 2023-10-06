//
//  BuskerPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct BuskerPageView: View {
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: BuskerPageViewModel
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            backgroundView()
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 5) {
                    
                    buskerPageImage
                    
                    buskerPageTitle
                    
                    buskerPageFollowButton
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}

//MARK: -3.PREVIEW
#Preview {
    BuskerPageView(viewModel: BuskerPageViewModel(busker: dummyBusker4))
}

//MARK: -4.EXTENSION
extension BuskerPageView {
    var buskerPageImage: some View {
        Image(viewModel.busker.image)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: 10){
                    Button {
                        UIApplication.shared.open(URL(string: viewModel.busker.youtube)!)
                    } label: { linkButton(name: YouTubeLogo) }
                    
                    Button { 
                        UIApplication.shared.open(URL(string: viewModel.busker.instagram)!)
                    } label: { linkButton(name: InstagramLogo) }
                    
                    Button { } label: { linkButton(name: SoundCloudLogo) }
                    
                }
                    .frame( height: 27)
                    .padding(.init(top: 0, leading: 0, bottom: 20, trailing: 15))
                ,alignment: .bottomTrailing )
    }
    
    var buskerPageTitle: some View {
        return VStack{
            Text(viewModel.busker.name)
                .font(.largeTitle)
                .fontWeight(.black)
                .scaleEffect(1.4)
            
            Text("Simple Imforamtion of This Artist")
                .font(.headline)
                .fontWeight(.heavy)
                .padding(.bottom, 20)
        }
        
    }
    
    var buskerPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.title2)
                .fontWeight(.black)
                .padding(.init(top: 7, leading: 30, bottom: 7, trailing: 30))
                .background{ Capsule().stroke(Color.white, lineWidth: 2) }
                .modifier(dropShadow())
        }
    }
}
