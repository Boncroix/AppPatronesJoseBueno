//
//  LoginViewModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation


final class LoginViewModel {
    
    // MARK: binding con UI
    var loginViewState: ((GenericSatatusLoad) -> Void)?
    
    // MARK: UseCase
    private let loginUseCase: LoginUseCaseProtocol
    
    // MARK: Init
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func onLoginButton(email: String?, password: String?) {
        loginViewState?(.loading(true))
        
        guard let email = email, isValid(email: email) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorEmail("Error en el email"))
            return
        }
        
        guard let password = password, isValid(password: password) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorPassword("Error en el password"))
            return
        }
        
        doLoginWith(email: email, password: password)
    }
    
    // Check email
    private func isValid(email: String) -> Bool {
        email.isEmpty == false && email.contains("@")
    }
    
    // Check password
    private func isValid(password: String) -> Bool {
        password.isEmpty == false && password.count >= 4
    }
    
    private func doLoginWith(email: String, password: String) {
        loginUseCase.login(user: email, password: password) { [weak self] token in
            DispatchQueue.main.async {
                self?.loginViewState?(.loaded)
            }
        } onError: { [weak self] networkError in
            DispatchQueue.main.async {
                var errorMessage = "Error Desconocido"
                switch networkError {
                case .malformeUrl:
                    errorMessage = "malformeUrl"
                case .dataFormating:
                    errorMessage = "dataFormating"
                case .noData:
                    errorMessage = "noData"
                case .errorCode(let error):
                    errorMessage = "errorCode \(error?.description ?? "Unknown")"
                case .tokenFormatError:
                    errorMessage = "tokenFormatError"
                case .decoding:
                    errorMessage = "decoding"
                case .other:
                    errorMessage = "other"
                case .encoding:
                    errorMessage = "encoding"
                }
                self?.loginViewState?(.errorNetwork(errorMessage))
            }
        }
    }
}

