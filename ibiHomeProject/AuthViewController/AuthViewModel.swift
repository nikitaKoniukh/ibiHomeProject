//
//  AuthViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation

protocol AuthViewModelDelegate: AnyObject {
    func errorOccured(message: String)
    func loginSuccessfull()
    func signUpSuccessfull()
}

class AuthViewModel {
    private let authService = AuthService()
    var isAuthenticated = false
    weak var delegate: AuthViewModelDelegate?
    
    var isUserPrevioslySigned: Bool {
        return authService.hasSavedCredentials()
    }
    
    func logout() {
        isAuthenticated = false
        authService.deleteCredentials()
    }
    
    //MARK: - Username and Password
    func login(username: String?, password: String?) {
        if let user = validateInputs(username: username, password: password) {
            if authService.validateCredentials(username: user.username, password: user.password) {
                isAuthenticated = true
                delegate?.loginSuccessfull()
            } else {
                delegate?.errorOccured(message: "Invalid username or password")
            }
        }
    }
    
    func signUp(username: String?, password: String?) {
        if let user = validateInputs(username: username, password: password) {
            authService.saveCredentials(username: user.username, password: user.password)
            delegate?.signUpSuccessfull()
        }
    }
    
    //MARK: - Biometric
    func loginWithBiometrics() {
        authService.authenticateWithBiometrics { [weak self] success in
            if success, let credentials = self?.authService.getSavedCredentials() {
                let components = credentials.split(separator: ":")
                if components.count == 2 {
                    self?.delegate?.loginSuccessfull()
                } else {
                    self?.delegate?.errorOccured(message: "Invalid credentials")
                }
            } else {
                self?.delegate?.errorOccured(message: "Failed to authenticate with biometrics")
            }
        }
    }
    
    func signUpWithBiometrics(username: String?, password: String?) {
        if let user = validateInputs(username: username, password: password) {
            authService.saveCredentials(username: user.username, password: user.password)
            
            authService.authenticateWithBiometrics { [weak self] success in
                if success {
                    self?.delegate?.signUpSuccessfull()
                } else {
                    self?.delegate?.errorOccured(message: "Failed to authenticate with biometrics")
                }
            }
        }
    }
    
    
    private func validateInputs(username: String?, password: String?) ->  User? {
        
        guard let username = username, let password = password else {
            delegate?.errorOccured(message: "All fields are required.")
            return nil
        }
        
        if username.count < 3 {
            delegate?.errorOccured(message: "Invalid username. It must be at least 3 characters long.")
            return nil
        }
        
        if password.count < 6 {
            delegate?.errorOccured(message: "Invalid password. It must be at least 6 characters long.")
            return nil
        }
        
        return User(username: username, password: password)
    }
}

