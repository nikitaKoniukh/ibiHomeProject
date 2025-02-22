//
//  AuthService.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import LocalAuthentication
import Security

class AuthService {
    private let keychainService = "com.example.auth"
    
    func deleteCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    func saveCredentials(username: String, password: String) {
        let credentials = "\(username):\(password)".data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecValueData as String: credentials,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func validateCredentials(username: String, password: String) -> Bool {
        if let savedCredentials = getSavedCredentials() {
            let components = savedCredentials.split(separator: ":")
            return components.count == 2 && components[0] == username && components[1] == password
        }
        return false
    }
    
    func hasSavedCredentials() -> Bool {
        return getSavedCredentials() != nil
    }
    
    func getSavedCredentials() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let retrievedData = item as? Data {
            return String(data: retrievedData, encoding: .utf8)
        }
        return nil
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login with Face ID / Touch ID") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }
}
