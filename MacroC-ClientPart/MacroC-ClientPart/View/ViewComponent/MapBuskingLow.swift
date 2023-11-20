//
//  MapBuskingLow.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import CoreLocation

struct MapBuskingLow: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @State private var addressString: String = ""
    var artist : Artist
    var busking : Busking
    
    //MARK: -2.BODY
    var body: some View {
        HStack(spacing: UIScreen.getWidth(10)) {
            CircleBlur(image: busking.artistImage ?? "", width: 120, strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))

                .padding(.horizontal, UIScreen.getWidth(10))
            VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
                HStack{
                    VStack(alignment: .leading ,spacing: 0){
                        Text(busking.stageName)
                            .font(.custom22black())
                            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                        HStack(spacing: UIScreen.getWidth(8)) {
                            Image(systemName: "bubble.left").font(.custom12semibold())
                            Text(busking.BuskingInfo) .font(.custom12bold())
                                .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.forward").font(.custom20semibold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                        .padding(.trailing, UIScreen.getHeight(8))
                }
                
                Divider()
                    .frame(height: 1.0)
                    .overlay(Color.white)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    .padding(.init(top: UIScreen.getHeight(2), leading: UIScreen.getWidth(0), bottom: UIScreen.getHeight(2), trailing: UIScreen.getWidth(0)))
                
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "calendar").font(.custom13semibold())
                    Text(formatDate()) .font(.custom12bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "clock").font(.custom13semibold())
                    Text("\(formatStartTime()) ~ \(formatEndTime())").font(.custom12bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                HStack(spacing: UIScreen.getWidth(8)) {
                    Image(systemName: "signpost.right").font(.custom13semibold())
                    Text("\(addressString)").font(.custom12bold())
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.frame(height: UIScreen.getHeight(130))
            Spacer()
        }
        .background(backgroundView())
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(height: UIScreen.getHeight(130))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: UIScreen.getWidth(1))
                .blur(radius: 2)
                .foregroundColor(Color.white.opacity(0.3))
                .padding(1)
        }
        .onAppear {
            awsService.getTargetArtist(buskingID: busking.id)
            reverseGeo(busking: busking)
        }
    }
}

//MARK: - 4.EXTENSION
extension MapBuskingLow {
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
        return formatter.string(from: busking.BuskingStartTime)
    }
    
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        return formatter.string(from: busking.BuskingEndTime)
    }
}
