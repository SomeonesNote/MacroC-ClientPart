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
    @Published var isShowModal: Bool = false
    @Published var selectedBusking: Busking? = nil
    @Published var address: String = "Enter the place."
    @Published var showSearchbar: Bool = false
    @Published var showAutocompleteModal: Bool = false
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var query: String = ""
    @Published var results: [GMSAutocompletePrediction] = []
    
    
    let buskings: [Busking] = dummyBuskingNow
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
                print("Error: \(error.localizedDescription)")
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
            print("Error: \(error.localizedDescription)")
        }
    }
}
