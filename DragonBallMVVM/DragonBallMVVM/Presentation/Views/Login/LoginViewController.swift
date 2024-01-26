//
//  LoginViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    private var viewModel: LoginViewModel
    
    // MARK: - Inits
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
    }
    
    // MARK: - IBAction
    @IBAction func didTapLoginButton(_ sender: Any) {
        viewModel.onLoginButton(email: emailTextField.text, password: passwordTextField.text)
    }
}

// MARK: - EXTENSION
extension LoginViewController {
    private func setObservers() {
        viewModel.checkToken()
        viewModel.loginViewState = { [weak self] status in
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
                self?.errorEmailLabel.isHidden = true
                self?.errorPasswordLabel.isHidden = true
            case .loaded:
                self?.loadingView.isHidden = true
                self?.navigateToHome()
            case .showErrorEmail(let error):
                self?.errorEmailLabel.text = error
                self?.errorEmailLabel.isHidden = (error == nil || error?.isEmpty == true)
            case .showErrorPassword(let error):
                self?.errorPasswordLabel.text = error
                self?.errorPasswordLabel.isHidden = (error == nil || error?.isEmpty == true)
            case .errorNetwor(let errorMessage):
                self?.loadingView.isHidden = true
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    // MARK: - Navigate
    private func navigateToHome() {
        let nextVC = HomeTableViewController()
        navigationController?.setViewControllers([nextVC], animated: true)
    }
    
    
    // MARK: - Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "ERROR NETWORK",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
