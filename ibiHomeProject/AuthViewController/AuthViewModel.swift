//
//  AuthViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation


class AuthViewModel {
    private let authService = AuthService()
    var isAuthenticated = false
    
    var isUserPrevioslySigned: Bool {
        return authService.hasSavedCredentials()
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        if authService.validateCredentials(username: username, password: password) {
            isAuthenticated = true
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func signUp(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard validateUsername(username) else {
            completion(false, "Invalid username. It must be at least 3 characters long.")
            return
        }
        guard validatePassword(password) else {
            completion(false, "Invalid password. It must be at least 6 characters long.")
            return
        }
        authService.saveCredentials(username: username, password: password)
        completion(true, nil)
    }
    
    
    func logout() {
        isAuthenticated = false
    }
    
    func loginWithBiometrics(completion: @escaping (Bool) -> Void) {
        authService.authenticateWithBiometrics { success in
            if success {
                self.isAuthenticated = true
            }
            completion(success)
        }
    }
    
    private func validateUsername(_ username: String) -> Bool {
        return username.count >= 3
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
