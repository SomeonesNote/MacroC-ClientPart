//
//  MacroC_ClientPartApp.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct MacroC_ClientPartApp: App {
    
    let APIKey = "AIzaSyBgin5aar0gpBJO8eV7DXH_kfo-zUHR1QQ"
    
    init() {
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
