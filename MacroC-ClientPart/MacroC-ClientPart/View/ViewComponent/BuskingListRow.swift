//
//  BuskingListRow.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import CoreLocation

struct BuskingListRow: View {
    
    //MARK: -1.PROPERTY
    @State private var addressString: String = ""
    var busking : Busking
    
    //MARK: -2.BODY
    var body: some View {
        HStack(spacing: UIScreen.getWidth(10)) {
            CircleBlur(image: busking.artistimage, width: 120, strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))
                .padding(.horizontal, UIScreen.getWidth(10))
            
            VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
                Text(busking.artistname)
                    .font(.custom22black())
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    .padding(.bottom, UIScreen.getHeight(4))
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "calendar").font(.custom16semibold())
                    Text(formatDate()) .font(.custom15bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "clock").font(.custom16semibold())
                    Text("\(formatStartTime()) ~ \(formatEndTime())").font(.custom15bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "signpost.right").font(.custom16semibold())
                    Text("\(addressString)").font(.custom15bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.frame(height: UIScreen.getHeight(130))
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appIndigo2), Color(appIndigo1)], startPoint: .bottomTrailing, endPoint: .topLeading)).opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(height: UIScreen.getHeight(130))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: UIScreen.getWidth(1))
                .blur(radius: 2)
                .foregroundColor(Color.white.opacity(0.1))
                .padding(0)
        }
        .onAppear {
            reverseGeo(busking: busking)
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    MainView(viewModel: MainViewModel())
}

//MARK: - 4.EXTENSION
extension BuskingListRow {
    func reverseGeo(busking: Busking) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: busking.latitude, longitude: busking.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let district = placemark.locality ?? ""
                let street = placemark.thoroughfare ?? ""
                let buildingNumber = placemark.subThoroughfare ?? ""
                self.addressString = "\(district) \(street) \(buildingNumber) "
            }
        }
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: busking.buskingstarttime)
    }
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: busking.buskingstarttime)
    }
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        return formatter.string(from: busking.buskingendtime)
    }
    
}
