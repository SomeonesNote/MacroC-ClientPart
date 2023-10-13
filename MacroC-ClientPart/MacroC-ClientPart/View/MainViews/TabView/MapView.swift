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
    @StateObject var viewModel = MapViewModel()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                GoogleMapView(viewModel: viewModel)
                    .ignoresSafeArea(.all, edges: .top)
                    .overlay(alignment: .top) {
                        MapViewSearchBar(viewModel: viewModel)
                            .padding(UIScreen.getWidth(4))
                    }
            }
            .background(backgroundView())
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $viewModel.isShowModal, onDismiss: {viewModel.isShowModal = false}) {
                if let busking = viewModel.selectedBusking {
                    BuskerInfoModalView(viewModel: BuskerInfoModalViewModel(busking: busking))
                        .presentationDetents([.height(UIScreen.getHeight(380))])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}


//MARK: - 3.PREVIEW
#Preview {
    MapView()
}
