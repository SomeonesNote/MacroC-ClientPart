//
//  MapBuskingInfoView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct MapBuskingInfoView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: MapBuskingInfoViewModel
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            backgroundView()
            VStack(spacing: 0) {
                Spacer()
                buskingInfoToolbar
                buskingInfoImage
                buskingTime
                buskingInfoAddress
                buskingInfoMap
            }
        }
        .frame(height: UIScreen.main.bounds.height * 2/3)
    }
}

//MARK: -3.PREVIEW
#Preview {
    VStack {
        MapBuskingInfoView(viewModel: MapBuskingInfoViewModel(busking: dummyBusking5))
            .previewLayout(.sizeThatFits)
            .background(Color.gray)
    }
}

//MARK: -4.EXTENSION
extension MapBuskingInfoView {
    var buskingInfoToolbar: some View {
        HStack{
            Text(viewModel.busking.name)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            Button(action: viewModel.toggleLike) {
                Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.trailing, 5)
            }
        }.padding(.init(top: 40, leading: 15, bottom: 40, trailing: 15))
    }
    
    var buskingInfoImage: some View {
        Image(viewModel.busking.image)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(color: .white, radius: 30)
            .overlay {
                Circle().stroke(Color.white, lineWidth: 2)
            }
    }
    
    var buskingTime: some View {
        Text(viewModel.busking.time)
            .font(.title3)
            .fontWeight(.black)
            .padding(.top)
    }
    
    var buskingInfoAddress: some View {
        HStack {
            Text(viewModel.addressString)
                .fontWeight(.semibold)
                .padding(.trailing, 10)
            Button { UIPasteboard.general.string = viewModel.addressString } label: {
                Image(systemName: "rectangle.on.rectangle")
                    .resizable()
                    .fontWeight(.heavy)
                    .frame(width: 15, height: 15)
            }
        }.padding(.bottom)
    }
    
    var buskingInfoMap: some View {
        MiniGoogleMapView(busking: viewModel.busking)
            .frame(height: UIScreen.main.bounds.height / 2)
            .cornerRadius(20)
    }
}
