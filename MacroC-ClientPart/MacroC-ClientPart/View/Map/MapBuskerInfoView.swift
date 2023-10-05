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
        ZStack {
            backgroundView()
            VStack(spacing: 10) {
                buskerInfoToolbar
                buskerInfoImage
                buskingTime
                Button { } label: { sheetBoxText(text: "더보기") }
                Button { } label: { sheetBoxText(text: "찾아가기") }
                Spacer()
            }.frame(height: 600)
        }
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
            Text(viewModel.busking.name)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            likeButton
        }.padding(.init(top: 50, leading: 15, bottom: 30, trailing: 15))
    }
    
    var buskerInfoImage: some View {
        Image(viewModel.busking.image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(Circle())
                .padding(.vertical, 30)
                .shadow(color: .white,radius: 30)
                .overlay { Circle().stroke(Color.white, lineWidth: 2) }
            
        }
    
    var buskingTime: some View {
        Text("13:00 ~ 16:00")
            .fontWeight(.black)
            .padding(.vertical, 10)
    }
}
