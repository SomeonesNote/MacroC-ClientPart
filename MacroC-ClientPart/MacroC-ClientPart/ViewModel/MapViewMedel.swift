//
//  MapViewMedel.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import GoogleMaps
import GooglePlaces

class MapViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var popModal: Bool = false
    
    @Published var selectedArtist: Artist? = nil
    @Published var selectedBusking: Busking? = nil
    
    @Published var buskingStartTime: Date = Date()
    @Published var buskingEndTime: Date = Date()
    @Published var BuskingInfo: String = ""
    
    @Published var address: String = "Enter the place."
    @Published var showSearchbar: Bool = false
    @Published var showAutocompleteModal: Bool = false
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var query: String = ""
    @Published var results: [GMSAutocompletePrediction] = []
    
    
    private var fetcher: GMSAutocompleteFetcher
    private var coordinator: Coordinator
    
    init() {
        let filter = GMSAutocompleteFilter()
        self.fetcher = GMSAutocompleteFetcher(filter: filter)
        self.coordinator = Coordinator()
        self.fetcher.delegate = coordinator
        self.coordinator.updateHandler = { [weak self] predictions in
            self?.results = predictions
        }
    }
    
    func sourceTextHasChanged(_ newValue: String) {
        fetcher.sourceTextHasChanged(newValue)
    }
    
    func getPlaceCoordinate(placeID: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID) { (place, error) in
            if let error = error {
                print("MapViewModel.getPlaceCoordinate.error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                completion(place.coordinate)
                self.query = ""
            }
        }
    }
    
    class Coordinator: NSObject, GMSAutocompleteFetcherDelegate {
        var updateHandler: (([GMSAutocompletePrediction]) -> Void)?
        
        func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
            updateHandler?(predictions)
        }
        
        func didFailAutocompleteWithError(_ error: Error) {
            print("MapViewModel.getPlaceCoordinate.error: \(error.localizedDescription)")
        }
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        if let busking = selectedBusking?.BuskingStartTime {
            return formatter.string(from: busking)
        }
        return ""
    }

    
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        if let busking = selectedBusking?.BuskingStartTime{
            return formatter.string(from: busking)
        }
        return ""
    }
    
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        if let busking = selectedBusking?.BuskingEndTime{
            return formatter.string(from: busking)
        }
        return ""
    }
    
    func makeBuskingTime() -> String{
        let startTime = formatStartTime()
        let endTime = formatEndTime()
        
        return "\(startTime) ~ \(endTime)"
    }
}
