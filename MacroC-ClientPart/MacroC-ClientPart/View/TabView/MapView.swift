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
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var mapViewOn: Bool = false
    
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                if mapViewOn {
                    GoogleMapView(viewModel: viewModel)
                        .ignoresSafeArea(.all, edges: .top)
                    
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
                    MapBuskingLow(artist: viewModel.selectedArtist ?? Artist(), busking: viewModel.selectedBusking ?? Busking())
                        .padding(4)
                }
            }
            .onTapGesture {
                viewModel.popModal = false
            }
            .background(backgroundView())
            .ignoresSafeArea(.keyboard)
            .navigationTitle("")
        }
        .onAppear {
            awsService.getAllArtistBuskingList{
                print(awsService.allBusking)
                mapViewOn = true }
        }
        .onDisappear {
            viewModel.popModal = false
            mapViewOn = false
        }
    }
}


//MARK: - 3.PREVIEW
#Preview {
    MapView()
}
