//
//  ApiTest.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/24.
//
//
//import SwiftUI
//
//
//
//struct ApiTest: View {
//    
//    @EnvironmentObject var awsService: AwsService
//    
//    
//
//    
//    var body: some View {
//        VStack {
//            let buskings = awsService.allAtrist} { artist in
//                return artist.buskings
//            }
//
//            VStack{
//                ForEach(buskings, id: \.self) { i in
//                        ApiTestBox(busking: i)
//                }
//            }
//        }
//        .onAppear {
//            awsService.getAllArtistList {
//                print(awsService.allAtrist)
//            }
//        }
//
//    }
//}
