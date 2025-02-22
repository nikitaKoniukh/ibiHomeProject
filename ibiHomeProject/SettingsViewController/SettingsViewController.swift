//
//  SettingsViewController.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let viewModel = SettingsViewModel()
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        darkModeSwitch.isOn = viewModel.isDarkModeEnabled
    }
    
    @IBAction func darkModeSwitchSelected(_ sender: UISwitch) {
        viewModel.setIsDarkModeEnabled(sender.isOn)
    }
    
    @IBAction func deleteUserButtonPressed(_ sender: UIButton) {
        viewModel.delleteUser()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        navigationController?.popToRootViewController(animated: false)
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func deleteUserComplete() {
        navigateToLogin()
    }
}
