//
//  AddBuskingPageViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import CoreLocation


class AddBuskingPageViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, GMSAutocompleteFetcherDelegate {
    @Published var markerAdressString: String = "address"
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var query: String = ""
    @Published var results: [GMSAutocompletePrediction] = []
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var latitude : Double = 0.0
    @Published var longitude : Double = 0.0
    
    private var fetcher: GMSAutocompleteFetcher
    @Published var locationManager: CLLocationManager
    
    override init() {
        let filter = GMSAutocompleteFilter()
        self.fetcher = GMSAutocompleteFetcher(filter: filter)
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.fetcher.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.results = predictions
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("AddBuskingPageViewModel.didFailAutocompleteWithError.error: \(error.localizedDescription)")
    }
    
    func sourceTextHasChanged(_ newValue: String) {
        fetcher.sourceTextHasChanged(newValue)
    }
    
    func getPlaceCoordinate(placeID: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID) { (place, error) in
            if let error = error {
                print("AddBuskingPageViewModel.getPlaceCoordinate.error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                completion(place.coordinate)
                self.query = ""
            }
        }
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: startTime)
    }
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: startTime)
    }
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: endTime)
    }
}
