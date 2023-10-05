//
//  GoogleMapView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

import SwiftUI
import GoogleMaps
import CoreLocation
import CoreLocationUI


struct GoogleMapView: UIViewRepresentable {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: context.coordinator.locationManager.location?.coordinate.latitude ?? 0, longitude: context.coordinator.locationManager.location?.coordinate.longitude ?? 0, zoom: 18.0)
        let view = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view.isMyLocationEnabled = true
        view.settings.myLocationButton = true
        view.settings.compassButton = true
        view.animate(toZoom: 15)
        
        view.delegate = context.coordinator
        view.setMinZoom(13, maxZoom: 19)
        
        context.coordinator.mapView = view
        context.coordinator.startLocationUpdates()
        
        for i in viewModel.buskings {
            let markerImage = UIImageView(image: UIImage(named: i.image))
            let customMarker = UIView()
            
            customMarker.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            customMarker.addSubview(markerImage)
            
            markerImage.center = customMarker.center
            markerImage.contentMode = .scaleToFill
            markerImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            markerImage.layer.borderColor = UIColor.white.cgColor
            markerImage.layer.borderWidth = 2
            markerImage.layer.cornerRadius = 50
            markerImage.layer.masksToBounds = true
            
            let marker = GMSMarker()
            marker.position = i.location
            marker.map = view
            marker.iconView = customMarker
            marker.isDraggable = false
            marker.userData = i
        }
        
        return view
    }
    
    func updateUIView(_ uiView: GMSMapView, context: UIViewRepresentableContext<GoogleMapView>) {
        if let previousCoordinate = context.coordinator.previousCoordinate {
            if previousCoordinate.latitude != viewModel.selectedCoordinate?.latitude || previousCoordinate.longitude != viewModel.selectedCoordinate?.longitude {
                if let coordinate = viewModel.selectedCoordinate {
                    let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17.0)
                    uiView.camera = camera
                    uiView.animate(toZoom: 15)
                }
            }
        } else if let coordinate = viewModel.selectedCoordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17.0)
            uiView.camera = camera
            uiView.animate(toZoom: 15)
        }
        
        context.coordinator.previousCoordinate = viewModel.selectedCoordinate
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    final class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var viewModel: MapViewModel
        var previousCoordinate: CLLocationCoordinate2D?
        let locationManager = CLLocationManager()
        
        init(viewModel: MapViewModel) {
            self.viewModel = viewModel
            super.init()
            locationManager.delegate = self
        }
        
        func startLocationUpdates() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                mapView?.animate(toLocation: location.coordinate)
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
                mapView?.camera = camera
            }
            locationManager.stopUpdatingLocation()
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            viewModel.isShowModal = true
            
            if let busking = marker.userData as? Busking {
                viewModel.selectedBusking = busking
            }
            return true
        }
    }
}
