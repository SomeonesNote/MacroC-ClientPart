//
//  UserAuth.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation
import AuthenticationServices

class AppleAuth: ObservableObject {
    @Published var showLoginView: Bool = false
    
    init() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { [weak self] (credentialState, error) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    self?.showLoginView = false
                }
            case .revoked, .notFound:
                DispatchQueue.main.async {
                    self?.showLoginView = true
                }
            default:
                break
            }
        }
    }
}
