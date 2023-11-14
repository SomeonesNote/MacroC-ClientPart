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
    
    @StateObject private var awsService = AwsService()
    
    let APIKey = "AIzaSyDF3d8OqWRipyjxQh7C2HF6KHn-C3YhSt8"
    
    init() {
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
    }
    var body: some Scene {
        WindowGroup {
            
            if awsService.isSignIn && awsService.isSignUp {
                ContentView().environmentObject(awsService)
                
            } else if awsService.isSignIn && !awsService.isSignUp {
                SignUpView().environmentObject(awsService)
                
            } else {
                LoginView().environmentObject(awsService)
                    .onAppear {
                       
                }
            }
        }
    }
}
