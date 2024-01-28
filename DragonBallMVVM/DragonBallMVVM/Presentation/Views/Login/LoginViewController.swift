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
    @IBOutlet weak var loginStackView: UIStackView!
    
    // MARK: - Properties
    private var viewModel: LoginViewModel
    private var saveUser: Bool = false
    
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
        setUpViewController()
    }
    
    // MARK: - IBAction
    @IBAction func didTapLoginButton(_ sender: Any) {
        viewModel.onLoginButton(email: emailTextField.text,
                                password: passwordTextField.text)
    }
}

// MARK: - SetObservers
extension LoginViewController {
    private func setObservers() {
        viewModel.loginViewState = { [weak self] status in
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
                self?.errorEmailLabel.isHidden = true
                self?.errorPasswordLabel.isHidden = true
            case .loaded:
                self?.loadingView.isHidden = true
                self?.navigateToHeroes()
            case .showErrorEmail(let error):
                self?.errorEmailLabel.text = error
                self?.errorEmailLabel.isHidden = (error == nil || error?.isEmpty == true)
            case .showErrorPassword(let error):
                self?.errorPasswordLabel.text = error
                self?.errorPasswordLabel.isHidden = (error == nil || error?.isEmpty == true)
            case .errorNetwork(let errorMessage):
                self?.loadingView.isHidden = true
                self?.showAlert(message: errorMessage)
            }
        }
    }

    private func navigateToHeroes() {
        let nextVC = HeroesCollectionViewController()
        navigationController?.setViewControllers([nextVC], animated: true)
    }
}
    
// MARK: - setUp
extension LoginViewController {
    private func setUpViewController() {
        let showPasswordButton = UIButton(type: .system)
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.addTarget(self, action: #selector(didTapShowPasswordButton), for: [.touchDown, .touchUpInside])
        
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func didTapShowPasswordButton(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
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
    


