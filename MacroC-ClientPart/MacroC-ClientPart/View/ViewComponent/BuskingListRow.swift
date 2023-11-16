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
    var artist : Artist
    var busking : Busking
    
    //MARK: -2.BODY
    var body: some View {
        HStack(spacing: UIScreen.getWidth(10)) {
            CircleBlur(image: artist.artistImage, width: 120, strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))
                .padding(.horizontal, UIScreen.getWidth(10))
            
            VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
                Text(artist.stageName)
                    .font(.custom22black())
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    .padding(.bottom, UIScreen.getHeight(4))
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "calendar").font(.custom14semibold())
                    Text(formatDate()) .font(.custom13bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "clock").font(.custom14semibold())
                    Text("\(formatStartTime()) ~ \(formatEndTime())").font(.custom13bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "signpost.right").font(.custom14semibold())
                    Text("\(addressString)").font(.custom13bold())
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
        return formatter.string(from: busking.BuskingStartTime)
    }
    
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: busking.BuskingStartTime)    }
    
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        return formatter.string(from: busking.BuskingEndTime)
    }
    
}
