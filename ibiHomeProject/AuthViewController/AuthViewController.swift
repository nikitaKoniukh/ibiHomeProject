//
//  AuthViewController.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import UIKit
import Lottie

final class AuthViewController: UIViewController {
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    
    var authViewModel: AuthViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authViewModel = AuthViewModel()
        authViewModel?.delegate = self
        setupUI()
        setupAnimation()
        navigationItem.hidesBackButton = true
        //        authViewModel?.logout()
    }
    
    private func setupUI() {
        if authViewModel?.isUserPrevioslySigned ?? false {
            loginButton.isHidden = false
            biometricButton.isHidden = false
        } else {
            loginButton.isHidden = true
            biometricButton.isHidden = true
        }
    }
    
    private func setupAnimation() {
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        authViewModel?.login(username: userNameTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func createNewUserButtonPressed(_ sender: UIButton) {
        showBiometricConfirmationPopup()
    }
    
    @IBAction func biometricButtonPressed(_ sender: UIButton) {
        authViewModel?.loginWithBiometrics()
    }
    
    private func navigateToMainScreen() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
        homeViewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}

extension AuthViewController: AuthViewModelDelegate {
    func errorOccured(message: String) {
        showAuthErrorPopup(message: message)
    }
    
    func loginSuccessfull() {
        navigateToMainScreen()
    }
    
    func signUpSuccessfull() {
        navigateToMainScreen()
    }
}

extension AuthViewController {
    private func showAuthErrorPopup(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showBiometricConfirmationPopup() {
        let alert = UIAlertController(title: "FaceId",
                                      message: "Do you want to use FaceId?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cacel", style: .cancel,  handler: { [weak self] _ in
            self?.navigateToMainScreen()
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.authViewModel?.signUpWithBiometrics(username: self?.userNameTextField.text, password: self?.passwordTextField.text)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    
}
