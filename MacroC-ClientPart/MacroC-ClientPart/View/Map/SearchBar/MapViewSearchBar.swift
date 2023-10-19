//
//  GooglePlacesSerchBar.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GooglePlaces

struct MapViewSearchBar: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack(spacing:0) {
            TextField("Search", text: $viewModel.query)
                .font(.custom13regular())
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10, corners: viewModel.results.isEmpty ? [.allCorners] : [.topLeft, .topRight])
                .overlay(alignment: .trailing,content: {
                    Button{ viewModel.query = "" } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.custom12regular())
                    }.padding()
                        .scaleEffect(1.2)
                })
                .onChange(of: viewModel.query) { newValue in
                    viewModel.sourceTextHasChanged(newValue)
                }
            if viewModel.results.isEmpty == false {
                List(viewModel.results, id: \.placeID) { result in
                    Text(result.attributedFullText.string)
                        .listRowBackground(Color.black.opacity(0.7))
                        .font(.custom12regular())
                        .onTapGesture {
                            viewModel.getPlaceCoordinate(placeID: result.placeID) { coordinate in
                                viewModel.selectedCoordinate = coordinate
                        }
                    }
                }
                .scrollDisabled(true)
                .listRowSeparatorTint(.white)
                .listStyle(.plain)
            } else {
        }
    }
        .frame(maxHeight: UIScreen.getWidth(274), alignment: .top)
        .cornerRadius(10)
    }
}

#Preview {
//    GooglePlaceSearchBar(viewModel: MapViewModel())
    MapView(viewModel: MapViewModel())
}
