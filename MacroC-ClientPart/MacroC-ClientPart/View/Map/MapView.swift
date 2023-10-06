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
                        GooglePlaceSearchBar(viewModel: viewModel)
                            .scrollDismissesKeyboard(.immediately)
                            .padding(4)
                    }
            }
            .background(backgroundView())
            .ignoresSafeArea(.keyboard)
            .hideKeyboardWhenTappedAround()
            .sheet(isPresented: $viewModel.isShowModal) {
                if let busking = viewModel.selectedBusking {
                    MapBuskerInfoView(viewModel: MapBuskerInfoViewModel(busking: busking))
                        .presentationDetents([.height(uiheight * 2/3)])
                }
            }
        }
    }
}


//MARK: - 3.PREVIEW
#Preview {
    MapView()
}
