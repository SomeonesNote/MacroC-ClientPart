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
    
    let APIKey = "AIzaSyDF3d8OqWRipyjxQh7C2HF6KHn-C3YhSt8"
    @StateObject private var userAuth = AppleAuth()
    @StateObject private var awsService = AwsService()
    
    init() {
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
    }
    
    var body: some Scene {
        WindowGroup {
            if awsService.isSignIn {
                ContentView().environmentObject(awsService)
            } else {
                SignInView().environmentObject(awsService)
            }
        }
        
//          WindowGroup {
//              if userAuth.showLoginView {
//                  SignInView() .environmentObject(userAuth)
//              } else {
//                  ContentView() .environmentObject(userAuth)
//              }
//          }
      }
  }
