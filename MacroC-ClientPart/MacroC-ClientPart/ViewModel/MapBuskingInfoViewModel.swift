//
//  MapBuskingInfoViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import CoreLocation

class MapBuskingInfoViewModel: ObservableObject {
    @Published var isClickedLike: Bool = false
    @Published var busking: Busking
    @Published var addressString: String = ""

    init(busking: Busking) {
        self.busking = busking
        reverseGeo(busking: busking)
    }

    func toggleLike() {
        isClickedLike.toggle()
    }

    private func reverseGeo(busking: Busking) {
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
