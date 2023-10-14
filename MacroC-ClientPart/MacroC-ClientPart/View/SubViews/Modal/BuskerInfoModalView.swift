//
//  MapBuskerInfoView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct BuskerInfoModalView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: BuskerInfoModalViewModel
    
    //MARK: -2.BODY
    var body: some View {
        VStack(spacing: UIScreen.getHeight(15)) {
                Spacer()
                buskerInfoToolbar
                buskerInfoImage
                buskingTime
            NavigationLink {
//                BuskerPageView(viewModel: BuskerPageViewModel(busker: viewModel.busking.))
            } label: { sheetBoxText(text: "더보기") }
                Button { } label: { sheetBoxText(text: "찾아가기") }
            }.background(backgroundView())
    }
}

//MARK: -3.PREVIEW
#Preview {
//    MapView()
    BuskerInfoModalView(viewModel: BuskerInfoModalViewModel(busking: dummyBusking4))
}


//MARK: -4. EXTENSION
extension BuskerInfoModalView {
    var likeButton: some View {
        Button {
            viewModel.toggleLike()
        } label: {
            Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isClickedLike ? Color(appRed) : Color.white)
                .font(.custom24light())
        }
    }
    
    var buskerInfoToolbar: some View {
        HStack{
            Text(viewModel.busking.buskername)
                .font(.custom24black())
            Spacer()
            likeButton
        }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(15)))
    }
    
    var buskerInfoImage: some View {
        CircleBlur(image: viewModel.busking.buskerimage, width: 120,strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))
        }
    
    var buskingTime: some View {
        Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
            .font(.custom14heavy())
            .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(30), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(30)))
            .overlay(alignment: .leading) {
                Image(systemName: "clock")
                    .font(.custom14semibold())
            }
    }
}
