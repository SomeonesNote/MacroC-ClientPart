//
//  UserAuth.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation
import AuthenticationServices

class UserAuth: ObservableObject {
    @Published var showLoginView: Bool = false
    
    init() {
        // Apple ID 자격 증명 상태 확인
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
