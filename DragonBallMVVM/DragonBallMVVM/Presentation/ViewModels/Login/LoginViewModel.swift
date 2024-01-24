//
//  LoginViewModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation


final class LoginViewModel {
    
    // MARK: binding con UI
    var loginViewState: ((LoginSatatusLoad) -> Void)?
    
    
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
        // TODO: Llamar al caso de uso
        }
}

