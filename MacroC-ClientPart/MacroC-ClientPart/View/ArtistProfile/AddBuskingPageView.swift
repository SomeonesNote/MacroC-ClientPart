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
    @EnvironmentObject var awsService : AwsService
    @ObservedObject var viewModel = AddBuskingPageViewModel()
    
    @State var informationText: String = ""
    @State var showPopover: Bool = false
    @State var emptyTextAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: UIScreen.getWidth(16)) {
                    informationHeader
                    informationTextField
                    locationHeader
                    map
                    timeHeader
                    datePickerView
                    Spacer()
                }
                .padding(.horizontal)
                .ignoresSafeArea(.keyboard)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if informationText == "" {
                            emptyTextAlert = true
                            print(informationText)
                        } else {
                            awsService.addBusking.BuskingStartTime = viewModel.startTime
                            awsService.addBusking.BuskingEndTime = viewModel.endTime
                            awsService.addBusking.latitude = viewModel.latitude
                            awsService.addBusking.longitude = viewModel.longitude
                            awsService.addBusking.BuskingInfo = informationText
                            awsService.postBusking()
                            withAnimation(.easeIn(duration: 0.4)) {
                                showPopover = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        showPopover = false
                                    }
                                }
                            }
                            dismiss()
                        }
                    } label: {
                        toolbarButtonLabel(buttonLabel: "Register").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
                            .foregroundColor(informationText == "" ? .gray : .white)
                    }
                }
            }
            .hideKeyboardWhenTappedAround()
            .background(backgroundView().ignoresSafeArea())
            .scrollDisabled(true)
            if showPopover { PopOverText(text: "공연이 등록되었습니다") } }
        .onChange(of: showPopover) { newValue in
            withAnimation { showPopover = newValue }
        }
    }
}


//MARK: -4.EXTENSION
extension AddBuskingPageView {
    
    var informationHeader: some View {
        HStack {
            roundedBoxText(text: "Information").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5)).scaleEffect(0.9)
            Spacer()
        }
    }

    var informationTextField: some View {
        VStack(spacing: 0) {
            TextField("Information", text: $informationText)
                .font(.custom12regular())
                .padding(UIScreen.getHeight(10))
                .background(Color.black.opacity(0.7))
                .cornerRadius(UIScreen.getHeight(10))
                HStack{
                    Text("Please insert busking information")
                        .font(.custom10semibold())
                        .padding(.init(top: UIScreen.getHeight(4), leading: UIScreen.getHeight(4), bottom: UIScreen.getHeight(0), trailing: UIScreen.getHeight(0)))
                        .foregroundStyle(emptyTextAlert ? Color.appRed : Color.clear)
                    Spacer()
                }
        }
    }
    
    var locationHeader: some View {
        HStack {
            roundedBoxText(text: "Location").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5)).scaleEffect(0.9)
            Spacer()
        }
    }
    
    var map: some View {
        ZStack(alignment: .top) {
                AddBuskingMapView(viewModel: viewModel)
                    .frame(height: UIScreen.getHeight(270))
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
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(3))
                AddBuskingSearchBar(viewModel: viewModel)
                    .padding(UIScreen.getHeight(3))
        }
    }
    
    var timeHeader: some View {
        HStack {
            roundedBoxText(text: "Time").padding(.leading, UIScreen.getWidth(15))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5)).scaleEffect(0.9)
            Spacer()
        }
    }
    
    var datePickerView: some View {
        VStack(spacing: UIScreen.getWidth(5)) {
            DatePicker(selection: $viewModel.startTime, displayedComponents: .date) {
                Text("공연 날짜")
                    .font(.custom13bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            } .font(.footnote)
            DatePicker(selection: $viewModel.startTime, displayedComponents: .hourAndMinute) {
                Text("시작 시간")
                    .font(.custom13bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            DatePicker(selection: $viewModel.endTime, displayedComponents: .hourAndMinute) {
                Text("종료 시간")
                    .font(.custom13bold()).padding(.leading, UIScreen.getWidth(5))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            customDivider().padding(.vertical, UIScreen.getWidth(8))
            VStack {
                Text(viewModel.formatDate())
                    .font(.custom13semibold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    .padding(.horizontal,UIScreen.getWidth(30))
                
                Text("\(viewModel.formatStartTime())   ~   \(viewModel.formatEndTime())")
                    .font(.custom13semibold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    .padding(.horizontal,UIScreen.getWidth(30))
            }
            .overlay(alignment: .leading) {
                VStack {
                    Image(systemName: "calendar").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    Image(systemName: "clock").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }.font(.custom14semibold())
            }
            
        }
        .onChange(of: viewModel.startTime) {newValue in
            viewModel.endTime = newValue
        }
        .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(15)))
        .background(Material.ultraThin.opacity(0.5))
        .shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
        .cornerRadius(10)
    }
}
