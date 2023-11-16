//
//  MapView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps

struct MapView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @StateObject var viewModel = MapViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                if viewModel.mapViewOn {
                    GoogleMapView(viewModel: viewModel)
                        .overlay(alignment: .top) {
                            MapViewSearchBar(viewModel: viewModel)
                                .padding(UIScreen.getWidth(4))
                        }
                } else {
                    backgroundView()
                        .overlay{
                            ProgressView()
                        }
                }
                if viewModel.popModal {
                    NavigationLink {
                        ArtistPageView(viewModel: ArtistPageViewModel(artist: viewModel.selectedArtist ?? Artist()))
                    } label: {
                        MapBuskingLow(artist: viewModel.selectedArtist ?? Artist(), busking: viewModel.selectedBusking ?? Busking())
                            .padding(4)
                    }
                }
            }
            .onTapGesture {
                viewModel.popModal = false
            }
            .background(backgroundViewForMap())
            .ignoresSafeArea(.keyboard)
            .navigationTitle("")
        }
        .onAppear {
            awsService.getAllArtistBuskingList{
                viewModel.mapViewOn = true }
        }
        .onDisappear {
            viewModel.popModal = false
            viewModel.mapViewOn = false
        }
    }
}
