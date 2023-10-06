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
    @Published var userBusker: UserBusker = dummyUserBusker
    @Published var markerAdressString: String = "address"
    @Published var currentTime = Date()
    @Published var query: String = ""
    @Published var results: [GMSAutocompletePrediction] = []
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    
    
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
    final class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var marker: GMSMarker?
        var parent: AddBuskingMapView
        let locationManager = CLLocationManager()
        var debounceTimer: Timer?
        
        init(_ parent: AddBuskingMapView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            marker?.position = mapView.camera.target
            
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reverseGeo(busking: position.target)
                }
            }
        }
        
        func startLocationUpdates() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                mapView?.animate(toLocation: location.coordinate)
            }
            locationManager.stopUpdatingLocation()
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.startUpdatingLocation()
                }
            default:
                
                break
            }
        }
        
        
        func reverseGeo(busking: CLLocationCoordinate2D) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: busking.latitude, longitude: busking.longitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    let district = placemark.locality ?? ""
                    let street = placemark.thoroughfare ?? ""
                    let buildingNumber = placemark.subThoroughfare ?? ""
                    self.parent.viewModel.markerAdressString = "\(district) \(street) \(buildingNumber)"
                }
            }
        }
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.results = predictions
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
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
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 a h시 mm분"
        return formatter.string(from: currentTime)
    }
}
