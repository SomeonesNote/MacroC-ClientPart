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
    @State var showPopover: Bool = false
    @Environment(\.dismiss) var dismiss
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView { // 키보드 뷰 밀림때문에 넣음
                VStack(spacing: UIScreen.getWidth(18)) {
//                    topbar
                    locationHeader
                    map
                    timeHeader
                    datePickerView
                    Spacer()
                    registerButton
                    Spacer()
                }
                .padding(.horizontal)
                .ignoresSafeArea(.keyboard)
                
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
                Text("Cancle")
                    .font(.custom14bold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            Spacer()
        }
        .padding(.init(top: UIScreen.getWidth(0), leading: UIScreen.getWidth(8), bottom: UIScreen.getWidth(8), trailing: UIScreen.getWidth(8)))
    }
    
    var locationHeader: some View {
        HStack {
            roundedBoxText(text: "Location").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            Spacer()
        }
    }
    
    var map: some View {
        ZStack(alignment: .top) {
            AddBuskingMapView(viewModel: viewModel)
                .frame(height: UIScreen.getHeight(290))
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
            roundedBoxText(text: "Time").padding(.leading, UIScreen.getWidth(10))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            Spacer()
        }.padding(.top, UIScreen.getHeight(20))
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
        .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(15)))
        .background(Material.ultraThin.opacity(0.3))
        .shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
        .cornerRadius(10)
    }
    
    var registerButton: some View {
        Button{
            withAnimation(.easeIn(duration: 0.4)) {
                showPopover = true
                feedback.notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        showPopover = false
                    }
                }
            }
            dismiss()
            print("공연 장소: \(viewModel.markerAdressString)")
            print("공연 시작: \(viewModel.startTime)")
            print("공연 종료: \(viewModel.endTime)")
        } label: {
            HStack{
                Spacer()
                Text("Register").font(.custom13bold()).shadow(color: .black.opacity(0.7),radius: UIScreen.getHeight(5))
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(LinearGradient(colors: [.appBlue2.opacity(0.2), .appIndigo2.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }
    }
}
