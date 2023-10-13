//
//  ProfileViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var selectedBusking: Busking = dummyBusking1
    @Published var isOn = false
    @Published var isT2 = true
    @Published var isShowBuskerProfile: Bool = false
    @Published var user: User = dummyUser
}
