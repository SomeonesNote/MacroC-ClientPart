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
        VStack(spacing: 20) {
            topbar
            locationHeader
            map
            Spacer()
            timeHeader
            datePickerView
            Spacer()
        }
        .padding(.horizontal)
        .background(backgroundView().hideKeyboardWhenTappedAround())
        .ignoresSafeArea(.keyboard)
    }
}

//MARK: -3.PREVIEW
#Preview {
    AddBuskingPageView(viewModel: AddBuskingPageViewModel())
}

//MARK: -4.EXTENSION
extension AddBuskingPageView {
    
    var topbar: some View {
        HStack {
            Button{
                dismiss()
            } label: {
                toolbarButtonLabel(buttonLabel: "Cancle")
            }
            Spacer()
            Button{
                //공연 데이터에 올리는 작업 수행
                print("공연 장소: \(viewModel.markerAdressString)")
                print("공연 시작: \(viewModel.startTime)")
                print("공연 종료: \(viewModel.endTime)")
            } label: {
                toolbarButtonLabel(buttonLabel: "Register")
            }
        }
        .padding(.init(top: 40, leading: 8, bottom: 8, trailing: 8))
    }
    
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
                        .font(.footnote)
                        .padding(.init(top: 8, leading: 30, bottom: 8, trailing: 30))
                        .background(LinearGradient(colors: [Color(appIndigo2),Color(appIndigo)], startPoint: .topLeading, endPoint: .bottomTrailing))
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
        VStack(spacing: 5) {
            DatePicker(selection: $viewModel.startTime, displayedComponents: .date) {
                Text("공연 날짜")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            DatePicker(selection: $viewModel.startTime, displayedComponents: .hourAndMinute) {
                Text("시작 시간")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            DatePicker(selection: $viewModel.endTime, displayedComponents: .hourAndMinute) {
                Text("종료 시간")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            customDivider()
                .padding(.vertical, 10)
            Text(viewModel.formatDate())
                .fontWeight(.semibold)
                .font(.subheadline)
            HStack {
                Text("\(viewModel.formatStartTime())   ~   \(viewModel.formatEndTime())")
                    .fontWeight(.semibold)
                    .font(.subheadline)
            }
        }
            .padding(.init(top: 10, leading: 15, bottom: 25, trailing: 15))
            .background(Material.ultraThin.opacity(0.5))
            .cornerRadius(10)
    }
}
