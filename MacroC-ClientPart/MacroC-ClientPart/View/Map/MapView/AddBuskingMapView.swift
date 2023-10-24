//
//  AddBuskingMapView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct AddBuskingMapView: UIViewRepresentable {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @ObservedObject var viewModel: AddBuskingPageViewModel
    
    
    func makeUIView(context: Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(
            withLatitude: viewModel.locationManager.location?.coordinate.latitude ?? 0, longitude: viewModel.locationManager.location?.coordinate.longitude ?? 0,
            zoom: Float(17))
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        mapView.setMinZoom(13, maxZoom: 19)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if let coordinate = viewModel.selectedCoordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
            uiView.animate(to: camera)
            viewModel.selectedCoordinate = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var marker: GMSMarker?
        var parent: AddBuskingMapView
        let locationManager = CLLocationManager()
        var debounceTimer: Timer?
        var initialSetupDone = false
        
        init(_ parent: AddBuskingMapView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }
        
        func startLocationUpdates() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            marker?.position = mapView.camera.target
            
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                self?.reverseGeo(busking: position.target)
            }
        }
        
        
        func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
            if !initialSetupDone {
                if let currentLocation = parent.viewModel.locationManager.location?.coordinate {
                    let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: Float(17))
                    mapView.camera = camera
                    initialSetupDone = true
                }
            } // 로케이션매니저에서 값을 받은 이후에 다시 카메라위치설정
            
            if self.marker == nil {
                let marker = GMSMarker()
                self.marker?.position = mapView.camera.target
                
                marker.map = mapView
                self.marker = marker

                
                let markerImage = UIImageView(image: UIImage(named: parent.awsService.user.artist?.artistImage ?? ""))
//                let markerImage = UIImageView(image: UII)
                let customMarker = UIImageView(image: UIImage(named: "markerpin"))
                
                customMarker.addSubview(markerImage)
                customMarker.translatesAutoresizingMaskIntoConstraints = false
                
                markerImage.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    markerImage.centerXAnchor.constraint(equalTo: customMarker.centerXAnchor),
                    markerImage.centerYAnchor.constraint(equalTo: customMarker.centerYAnchor, constant: -UIScreen.getWidth(4)),
                    markerImage.widthAnchor.constraint(equalToConstant: UIScreen.getWidth(74)),
                    markerImage.heightAnchor.constraint(equalToConstant: UIScreen.getWidth(74))
                ])
                
                markerImage.contentMode = .scaleAspectFill
                markerImage.layer.borderColor = UIColor.white.cgColor
                markerImage.layer.borderWidth = UIScreen.getWidth(2)
                markerImage.layer.cornerRadius = 37
                markerImage.layer.masksToBounds = true
                marker.iconView = customMarker
                
            } else {
                self.marker?.position = mapView.camera.target
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
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }
}

//MARK: -3.PREVIEW
#Preview {
    AddBuskingMapView(viewModel: AddBuskingPageViewModel())
}

