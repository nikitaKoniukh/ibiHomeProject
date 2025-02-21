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
    
    var authViewModel: AuthViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authViewModel = AuthViewModel()
        setupUI()
        setupAnimation()
        navigationItem.hidesBackButton = true
    }

    private func setupUI() {
        if authViewModel?.isUserPrevioslySigned ?? false {
            loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
            loginButton.tintColor = .systemPink
            
        } else {
            loginButton.isHidden = true
        }
    }

    private func setupAnimation() {
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
            
    }
    
    @IBAction func createNewUserButtonPressed(_ sender: UIButton) {
        authViewModel?.signUp(username: userNameTextField.text ?? "", password: passwordTextField.text ?? "", completion: { [weak self] result, message in
//            if !result, let message {
//                self?.showPopup(message: message)
            //            } else {
            let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            homeViewController.navigationItem.hidesBackButton = true
            self?.navigationController?.pushViewController(homeViewController, animated: true)
            //            }
        })
    }
    
    private func showPopup(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
}

