//
//  SettingsViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 22/02/2025.
//

import UIKit

protocol SettingsViewModelDelegate: AnyObject {
    func deleteUserComplete()
}
class SettingsViewModel {
    
    private let authService = AuthService()
    weak var delegate: SettingsViewModelDelegate?
    
    var isDarkModeEnabled: Bool {
        return UserDefaults.standard.integer(forKey: "theme") == 2
    }
    
    func setIsDarkModeEnabled(_ isDarkModeEnabled: Bool) {
        let newStyle: UIUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        UserDefaults.standard.set(newStyle.rawValue, forKey: "theme")
        
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = newStyle
            }
        }
    }
    
    func delleteUser() {
        authService.deleteCredentials()
        delegate?.deleteUserComplete()
    }
}
