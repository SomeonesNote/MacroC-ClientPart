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
        ScrollView { // 키보드 뷰 밀림때문에 넣음
            VStack(spacing: UIScreen.getWidth(20)) {
                        topbar
                        locationHeader
                        map
                        timeHeader
                        datePickerView
                        Spacer()
                    }
                .padding(.horizontal)
                .background(backgroundView().ignoresSafeArea().hideKeyboardWhenTappedAround())
                .ignoresSafeArea(.keyboard)
        }.scrollDisabled(true)
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
                    .shadow(color: .black.opacity(0.7),radius: 5)
            }
            Spacer()
            Button{
                //공연 데이터에 올리는 작업 수행
                print("공연 장소: \(viewModel.markerAdressString)")
                print("공연 시작: \(viewModel.startTime)")
                print("공연 종료: \(viewModel.endTime)")
            } label: {
                toolbarButtonLabel(buttonLabel: "Register")
                    .shadow(color: .black.opacity(0.7),radius: 5)
            }
        }
        .padding(.init(top: UIScreen.getWidth(0), leading: UIScreen.getWidth(8), bottom: UIScreen.getWidth(8), trailing: UIScreen.getWidth(8)))
    }
    
    var locationHeader: some View {
        HStack {
            roundedBoxText(text: "Location").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: 5)
            Spacer()
        }
    }
    
    var map: some View {
        ZStack(alignment: .top) {
            AddBuskingMapView(viewModel: viewModel)
                .frame(height: UIScreen.getHeight(300))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .bottom) {
                    Text(viewModel.markerAdressString)
                        .font(.custom12semibold())
                        .padding(.init(top: UIScreen.getWidth(8), leading: UIScreen.getWidth(30), bottom: UIScreen.getWidth(8), trailing: UIScreen.getWidth(30)))
                        .background(LinearGradient(colors: [Color(appIndigo2),Color(appIndigo)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(20)
                        .modifier(dropShadow())
                        .padding(UIScreen.getHeight(5))
                }
                .shadow(color: .black.opacity(0.4),radius: 3)
            AddBuskingSearchBar(viewModel: viewModel)
                .padding(UIScreen.getHeight(3))
        }
    }
    
    var timeHeader: some View {
        HStack {
            roundedBoxText(text: "Time").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: 5)
            Spacer()
        }.padding(.top, UIScreen.getHeight(30))
    }
    
    var datePickerView: some View {
        VStack(spacing: 5) {
            DatePicker(selection: $viewModel.startTime, displayedComponents: .date) {
                Text("공연 날짜")
                    .font(.custom14bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: 5)
            } .font(.footnote)
            DatePicker(selection: $viewModel.startTime, displayedComponents: .hourAndMinute) {
                Text("시작 시간")
                    .font(.custom14bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: 5)
            }
            DatePicker(selection: $viewModel.endTime, displayedComponents: .hourAndMinute) {
                Text("종료 시간")
                    .font(.custom14bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: 5)
            }
            
            customDivider().padding(.vertical, UIScreen.getWidth(15))
            VStack {
                Text(viewModel.formatDate())
                    .font(.custom14semibold())
                    .shadow(color: .black.opacity(0.7),radius: 5)
                    .padding(.horizontal,UIScreen.getWidth(30))
                
                Text("\(viewModel.formatStartTime())   ~   \(viewModel.formatEndTime())")
                    .font(.custom14semibold())
                    .shadow(color: .black.opacity(0.7),radius: 5)
                    .padding(.horizontal,UIScreen.getWidth(30))
                    }
            .overlay(alignment: .leading) {
                VStack {
                    Image(systemName: "calendar").shadow(color: .black.opacity(0.7),radius: 5)
                    Image(systemName: "clock").shadow(color: .black.opacity(0.7),radius: 5)
                }.font(.custom16semibold())
            }

        }
        .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(25), trailing: UIScreen.getWidth(15)))
        .background(Material.ultraThin.opacity(0.5))
        .cornerRadius(10)
    }
}
