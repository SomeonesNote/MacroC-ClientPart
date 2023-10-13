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
            buskingTime
            buskingInfoAddress
            buskingInfoMap
        }.background(backgroundView())
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
            buskingInfoImage
            Text(viewModel.busking.buskername)
                .font(.custom24black())
            Spacer()
            Button(action: viewModel.toggleLike) {
                Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                    .font(.custom24semibold())
            }
        }.padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(5), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(15)))
    }
    
    var buskingInfoImage: some View {
        Image(viewModel.busking.buskerimage)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.getWidth(40), alignment: .center)
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
        VStack(spacing: UIScreen.getHeight(3)) {
            Text(viewModel.formatDate()) //TODO: 시간모델
                .font(.custom14heavy())
                .padding(.horizontal, 30)
                .overlay(alignment: .leading) {
                    Image(systemName: "calendar")
                }
            Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
                .font(.custom14heavy())
                .padding(.horizontal, 30)
                .overlay(alignment: .leading) {
                    Image(systemName: "clock")
                }
        }
    }
    var buskingInfoAddress: some View {
        HStack {
            Text(viewModel.addressString)
                .font(.custom14bold())
                .padding(.trailing, 10)
            
        }.padding(UIScreen.getWidth(15))
            .overlay(alignment: .trailing) {
                Button { UIPasteboard.general.string = viewModel.addressString } label: {
                    Image(systemName: "rectangle.on.rectangle")
                        .frame(width: UIScreen.getWidth(13), height: UIScreen.getHeight(10))
                }
            }
    }
    
    var buskingInfoMap: some View {
        MiniGoogleMapView(busking: viewModel.busking)
            .frame(height: UIScreen.getHeight(300))
            .cornerRadius(20)
            .padding(.init(top: UIScreen.getWidth(0), leading: UIScreen.getWidth(8), bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(8)))
    }
}
