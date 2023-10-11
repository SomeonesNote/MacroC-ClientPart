//
//  MapBuskerInfoView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct MapBuskerInfoView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: MapBuskerInfoViewModel
    
    //MARK: -2.BODY
    var body: some View {
            VStack(spacing: 10) {
                buskerInfoToolbar
                buskerInfoImage
                buskingTime
                Button { } label: { sheetBoxText(text: "더보기") }
                Button { } label: { sheetBoxText(text: "찾아가기") }
                Spacer()
            }.background(backgroundView())
    }
}

//MARK: -3.PREVIEW
#Preview {
    MapBuskerInfoView(viewModel: MapBuskerInfoViewModel(busking: dummyBusking5))
}

//MARK: -4. EXTENSION
extension MapBuskerInfoView {
    var likeButton: some View {
        Button {
            viewModel.toggleLike()
        } label: {
            Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                .font(.title)
                .foregroundColor(.white)
                .padding(.trailing, 5)
        }
    }
    
    var buskerInfoToolbar: some View {
        HStack{
            Text(viewModel.busking.buskername)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            likeButton
        }.padding(.init(top: 50, leading: 15, bottom: 10, trailing: 15))
    }
    
    var buskerInfoImage: some View {
        Image(viewModel.busking.buskerimage)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180, alignment: .center)
                .clipShape(Circle())
                .padding(.vertical, 30)
                .shadow(color: .white.opacity(0.2),radius: 20)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 5)
                        .blur(radius: 4)
                        .foregroundColor(Color(appSky).opacity(0.4))
                        .padding(0)
                }

            
        }
    
    var buskingTime: some View {
        Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
            .font(.subheadline)
            .fontWeight(.heavy)
            .padding(.bottom, 20)
    }
}
