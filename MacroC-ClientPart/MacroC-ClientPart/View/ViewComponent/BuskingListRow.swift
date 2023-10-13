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
        HStack(spacing: UIScreen.getWidth(15)) {
            Image(busking.buskerimage)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading,spacing: UIScreen.getWidth(1)) {
                Text(busking.buskername)
                    .font(.custom20black())
                    .padding(.bottom, 9)
                Text(formatDate())
                    .font(.custom12bold())
                    .fontWeight(.semibold)
                Text("\(formatStartTime()) ~ \(formatEndTime())") // TODO: 시간 포맷 다시 설정해야
                    .font(.custom12bold())
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                Text("\(addressString)")
                    .font(.custom14bold())
                    .fontWeight(.heavy)
            }
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appIndigo2), Color(appIndigo1)], startPoint: .bottomTrailing, endPoint: .topLeading)).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(height: UIScreen.getHeight(130))
        .modifier(dropShadow())
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: 1)
                .blur(radius: 2)
                .foregroundColor(Color(appBlue).opacity(0.2))
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
