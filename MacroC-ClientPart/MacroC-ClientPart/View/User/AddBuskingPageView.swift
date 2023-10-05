//
//  AddBuskingPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps

struct AddBuskingPageView: View {
    
    //MARK: -1.PROPERTY
    @StateObject var viewModel = AddBuskingPageViewModel()
    @Environment(\.dismiss) var dismiss
    
    //MARK: -2.BODY
    var body: some View {
        GeometryReader { Geo in
            VStack(spacing: 20) {
                HStack {
                    Button{
                        dismiss()
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Cancle")
                    }
                    Spacer()
                    Button{
                        //공연 데이터에 올리는 작업 수행
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Register")
                    }
                }
                .padding(.all, 8)
                
                locationHeader
                map
                Spacer()
                timeHeader
                datePickerView
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(backgroundView())
        .hideKeyboardWhenTappedAround()
        .ignoresSafeArea(.keyboard)
//        .toolbar{
//            ToolbarItem(placement: .topBarTrailing) {
//                Button{
//                    //공연 데이터에 올리는 작업 수행
//                } label: {
//                    Text("등록")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                }
//            }
//        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    AddBuskingPageView(viewModel: AddBuskingPageViewModel())
}

//MARK: -4.EXTENSION
extension AddBuskingPageView {
    var locationHeader: some View {
        HStack {
            roundedBoxText(text: "Location")
            Spacer()
        }
    }
    
    var map: some View {
        ZStack(alignment: .top) {
            AddBuskingMapView(viewModel: viewModel)
                .frame(height: uiheight/2.5) // 이거 값 동적으로 수정해야 함
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .bottom) {
                    Text(viewModel.markerAdressString)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .padding(.init(top: 8, leading: 30, bottom: 8, trailing: 30))
                        .background(Color(appIndigo1).opacity(0.9))
                        .cornerRadius(20)
                        .modifier(dropShadow())
                        .padding(5)
                }
            AddBuskingSearchBar(viewModel: viewModel)
                .padding(3)
        }
    }
    
    var timeHeader: some View {
        HStack {
            roundedBoxText(text: "Time")
            Spacer()
        }
    }
    
    var datePickerView: some View {
        VStack(spacing: 20) {
            DatePicker(selection: $viewModel.currentTime) {
                Text("")
            }
            Text(viewModel.formatDate())
                .fontWeight(.semibold)
                .font(.headline)
        }
        .padding(.init(top: 10, leading: 10, bottom: 25, trailing: 10))
//        .background(Material.ultraThin.opacity(0.8))
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appBlue).opacity(0.7), Color(appIndigo)], startPoint: .bottomTrailing, endPoint: .topLeading)).opacity(0.4))
        .cornerRadius(10)
    }
}
