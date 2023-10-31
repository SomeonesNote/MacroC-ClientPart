//
//  KeychainItem.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

struct KeychainItem {
    // MARK: -Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    // MARK: -Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
    
    // MARK: -Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: -Keychain access
    
    func readItem() throws -> String {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func saveItem(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readItem()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            /*
             No password was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    /*
     For the purpose of this demo app, the user identifier will be stored in the device keychain.
     You should store the user identifier in your account management system.
     */
    static var currentUserIdentifier: String { //애플에서 받아오는 유저아이덴티파이어
        do {
            let storedIdentifier = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return "currentUserIdentifier error!"
        }
    }
    
    static var currentFuid: String { // 파이어베이스에서 주는 UID
        do {
            let storedfuid = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "fuid").readItem()
            return storedfuid
        } catch {
            return "currentFuid error!"
        }
    }
    
    static var currentFirebaseToken: String { // 파이어베이스에서 받아오는 토큰
        do {
            let storedToken = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "firebaseToken").readItem()
            return storedToken
        } catch {
            return "currentFirebaseToken error!"
        }
    }
    
    static var currentTokenResponse: String { //서버에서 받아오는 토큰 // 이값으로 통신하면 됨 // 통신용 헤더
        do {
            let storedTokenResponse = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").readItem()
            return storedTokenResponse
        } catch {
            return "currentTokenResponse error!"
        }
    }
    
    static func deleteFirebaseTokenFromKeychain() { //
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "firebaseToken").deleteItem()
        } catch {
            print("Keychain.deleteUserIdentifierFromKeychain.error : Unable to delete firebaseToken from keychain")
        }
    }
    
    static func deleteFuidFromKeychain() { //
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "fuid").deleteItem()
        } catch {
            print("Keychain.deleteUserIdentifierFromKeychain.error : Unable to delete fuid from keychain")
        }
    }

    //서버에서 받아오는 토큰 // 이값으로 통신하면 됨 // 통신용 헤더
        static func deleteTokenResponseFromKeychain() { //
            do {
                try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
            } catch {
                print("Keychain.deleteTokenResponseFromKeychain.error : Unable to delete fuid from keychain")
            }
        }
    
    static func deleteUserIdentifierFromKeychain() { //
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").deleteItem()
        } catch {
            print("Keychain.deleteUserIdentifierFromKeychain.error : Unable to delete userIdentifier from keychain")
        }
    }

}
