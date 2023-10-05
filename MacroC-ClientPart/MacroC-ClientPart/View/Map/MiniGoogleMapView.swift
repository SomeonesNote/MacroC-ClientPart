//
//  MiniGoogleMapView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps

  
struct MiniGoogleMapView: UIViewRepresentable {
    
    //MARK: -1.PROPERTY
    let busking: Busking
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: busking.latitude, longitude: busking.longitude, zoom: 17.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let markerImage = UIImageView(image: UIImage(named: busking.image))
        let customMarker = UIView()
        
        customMarker.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        customMarker.addSubview(markerImage)
        
        markerImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markerImage.centerXAnchor.constraint(equalTo: customMarker.centerXAnchor),
            markerImage.centerYAnchor.constraint(equalTo: customMarker.centerYAnchor),
            markerImage.widthAnchor.constraint(equalToConstant: 100),
            markerImage.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        markerImage.center = customMarker.center
        markerImage.contentMode = .scaleToFill
        markerImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        markerImage.layer.borderColor = UIColor.white.cgColor
        markerImage.layer.borderWidth = 2
        markerImage.layer.cornerRadius = 50
        markerImage.layer.masksToBounds = true
        
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: busking.latitude, longitude: busking.longitude)
        marker.map = mapView
        marker.iconView = customMarker
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
    
}

//MARK: -3.PREVIEW
#Preview {
    MiniGoogleMapView(busking: dummyBusking4)
}
