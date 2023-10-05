//
//  EditBuskerView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditBuskerView: View {
    
    @State private var searchText = ""
    let data: [String] = ["Apple", "Banana", "Orange", "Pineapple", "Grape", "Cherry"]
    
    var filteredData: [String] {
        if searchText.isEmpty {
            return data
        } else {
            return data.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            List(filteredData, id: \.self) { item in
                Text(item)
            }
        }
    }
}

#Preview {
    EditBuskerView()
}
