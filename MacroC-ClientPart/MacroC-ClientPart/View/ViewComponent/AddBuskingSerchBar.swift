//
//  AddBuskingSerchBar.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GooglePlaces

struct AddBuskingSearchBar: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: AddBuskingPageViewModel
    
    //MARK: -2.BODY
    var body: some View {
        VStack(spacing:0) {
            TextField("Search", text: $viewModel.query)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10, corners: viewModel.results.isEmpty ? [.allCorners] : [.topLeft, .topRight])
                .overlay(alignment: .trailing,content: {
                    Button{ viewModel.query = "" } label: {
                        Image(systemName: "multiply.circle.fill")
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
                        .font(.custom14regular())
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
