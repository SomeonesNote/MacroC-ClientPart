//
//  MapBuskingInfoView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct MapBuskingModalView: View {

    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService : AwsService
    @ObservedObject var viewModel: MapBuskingModalViewModel
    
    @State var showPopover: Bool = false
    @State var showReport: Bool = false
   

    //MARK: -2.BODY
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                buskingInfoToolbar
                buskingTime
                buskingInfoAddress
                buskingInfoMap
            }
            if showPopover { PopOverText() } }
        .onChange(of: showPopover) { newValue in
            withAnimation { showPopover = newValue }
        }
        .background(backgroundView())
        .sheet(isPresented: $showReport, onDismiss: onDismiss){
            ReportPage(artistID: viewModel.artist.id)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

//MARK: -3.PREVIEW
//#Preview {
//    MainView()
//}

//MARK: -4.EXTENSION
extension MapBuskingModalView {
    var buskingInfoToolbar: some View {
        HStack(spacing: UIScreen.getWidth(10)){
            buskingInfoImage.shadow(color: .black.opacity(0.2),radius: UIScreen.getWidth(5))
            Text(viewModel.artist.stageName)
                .font(.custom24black())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            Spacer()
            Button{
               showReport = true
//                feedback.notificationOccurred(.success)
            } label: {
                Image(systemName: "light.beacon.max.fill")
                    .font(.custom16bold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }.padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(7), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(15)))
    }

    var buskingInfoImage: some View {
        CircleBlur(image: viewModel.artist.artistImage, width: UIScreen.getWidth(40))
            .overlay {
                Circle().stroke(lineWidth: 1).opacity(0.8)
            }
    }

    var buskingTime: some View {
        HStack {
            VStack(spacing: UIScreen.getHeight(3)) {
                Text(viewModel.formatDate()) //TODO: 시간모델
                    .font(.custom13heavy())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    .padding(.horizontal, UIScreen.getWidth(30))

                Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
                    .font(.custom13heavy())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    .padding(.horizontal, UIScreen.getWidth(30))

            } .overlay(alignment: .leading) {
                VStack(spacing: UIScreen.getHeight(3)) {
                    Image(systemName: "calendar")
                        .font(.custom14semibold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    Image(systemName: "clock")
                        .font(.custom14semibold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    var buskingInfoAddress: some View {
        HStack {
            Text(viewModel.addressString)
                .font(.custom13heavy())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                .padding(.horizontal, UIScreen.getWidth(30))

        }

        .overlay(alignment: .leading) {
            Image(systemName: "signpost.right")
                .frame(width: UIScreen.getWidth(13), height: UIScreen.getHeight(10))
                .font(.custom14semibold())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
        .overlay(alignment: .trailing) {
            Button { UIPasteboard.general.string = viewModel.addressString
                withAnimation(.easeIn(duration: 0.4)) {
                    showPopover = true
                    feedback.notificationOccurred(.success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            showPopover = false
                        }
                    }
                }
            } label: {
                Image(systemName: "rectangle.on.rectangle")
                    .resizable()
                    .frame(width: UIScreen.getWidth(15), height: UIScreen.getHeight(15))
                    .font(.custom14semibold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }
        .padding(.init(top: UIScreen.getHeight(5), leading: UIScreen.getWidth(0), bottom: UIScreen.getHeight(0), trailing: UIScreen.getWidth(0)))
    }

    var buskingInfoMap: some View {
        CropedGoogleMapView(busking: viewModel.busking, artist: viewModel.artist)
            .frame(height: UIScreen.getHeight(300))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            .overlay {
                RoundedRectangle(cornerRadius: 20).stroke(lineWidth: UIScreen.getWidth(2)).shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    .foregroundStyle(LinearGradient(colors: [.white, .white, .appSky.opacity(0.6), .white, .appSky.opacity(0.6), .white], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(8), bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(8)))
    }
    
    func onDismiss() {
        showReport = false
    }
}
