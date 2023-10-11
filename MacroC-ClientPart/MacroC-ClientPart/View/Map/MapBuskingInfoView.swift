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
            VStack(spacing: 0) {
                Spacer()
                buskingInfoToolbar
                buskingInfoImage
                buskingTime
                buskingInfoAddress
                buskingInfoMap
            }
            .background(backgroundView())
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
            Text(viewModel.busking.buskername)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            Button(action: viewModel.toggleLike) {
                Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.trailing, 5)
            }
        }.padding(.init(top: 40, leading: 15, bottom: 30, trailing: 15))
    }
    
    var buskingInfoImage: some View {
        Image(viewModel.busking.buskerimage)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .shadow(color: .white.opacity(0.2), radius: 20)
            .overlay {
                Circle()
                    .stroke(lineWidth: 5)
                    .blur(radius: 2)
                    .foregroundColor(Color(appSky).opacity(0.4))
                    .padding(0)
            }
    }
    
    var buskingTime: some View {
        VStack {
            Text(viewModel.formatDate()) //TODO: 시간모델
                .font(.headline)
                .fontWeight(.heavy)
                .padding(.top)
            Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
                .font(.subheadline)
                .fontWeight(.heavy)
        }
    }
    var buskingInfoAddress: some View {
        HStack {
            Text(viewModel.addressString)
                .font(.subheadline)
                .fontWeight(.heavy)
                .padding(.trailing, 10)
            Button { UIPasteboard.general.string = viewModel.addressString } label: {
                Image(systemName: "rectangle.on.rectangle")
                    .resizable()
                    .fontWeight(.bold)
                    .frame(width: 15, height: 15)
            }
        }.padding(.vertical)
    }
    
    var buskingInfoMap: some View {
        MiniGoogleMapView(busking: viewModel.busking)
            .frame(height: UIScreen.main.bounds.height / 3)
            .cornerRadius(20)
            .padding(.horizontal, 8)
            .padding(.bottom, 20)
    }
}
