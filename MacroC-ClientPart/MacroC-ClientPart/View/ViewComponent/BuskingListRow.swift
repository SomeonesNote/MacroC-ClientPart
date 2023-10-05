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
        HStack(spacing: 10) {
            Image(busking.image)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading,spacing: 1) {
                Text(busking.name)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding(.bottom, 9)
                Text("2023/12/23")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text(busking.time)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                Text("\(addressString)")
                    .font(.callout)
                    .fontWeight(.heavy)
            }
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(appBlue), Color(appIndigo1)], startPoint: .bottomTrailing, endPoint: .topLeading)).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: 140)
        .modifier(dropShadow())
        .onAppear {
            reverseGeo(busking: busking)
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    MainView()
}

//MARK: - 4.EXTENSION
extension BuskingListRow {
    func reverseGeo(busking: Busking) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: busking.location.latitude, longitude: busking.location.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let district = placemark.locality ?? ""
                let street = placemark.thoroughfare ?? ""
                let buildingNumber = placemark.subThoroughfare ?? ""
                self.addressString = "\(district) \(street) \(buildingNumber) "
            }
        }
    }
}
