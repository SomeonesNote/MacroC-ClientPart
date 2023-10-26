//
//  ApiTestBox.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/24.
//

import SwiftUI

struct ApiTestBox: View {
//    var artist: Artist
    var busking: Busking
    var body: some View {
        VStack {
//            Text("artistName: \(artist.stageName)")
//            Text("ArtistImage: \(artist.artistImage)")
            
            Text("busking id: \(busking.id)")
            Text("lat: \(busking.latitude)")
            Text("lon: \(busking.longitude)")
            Text("startTime: \(busking.BuskingStartTime)")
            Text("endTime: \(busking.BuskingEndTime)")
            
            
        }
    }
}

struct ApiTestBox1: View {
    var artist: Artist
    var body: some View {
        VStack {
            Text("id: \(artist.id)")
            Text("name: \(artist.stageName)")
            Text("info: \(artist.artistInfo)")
            Text("image: \(artist.artistImage)")
            
            
        }
    }
}
