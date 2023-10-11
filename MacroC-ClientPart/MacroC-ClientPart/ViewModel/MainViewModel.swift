//
//  MainViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/09.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var isClickedBuskingInfo: Bool = false
    @Published var selectedBusking: Busking = dummyBusking1
    @Published var user : User = dummyUser
}
