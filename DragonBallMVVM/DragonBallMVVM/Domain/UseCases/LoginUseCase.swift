//
//  LoginUseCase.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation


protocol LoginUseCaseProtocol {
    func login(user: String,
               password: String,
               onSuscces: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    
    private var token: String? {
        get {
            if let token = LocalDataModel.getToken(){
                return token
            }
            return nil
        }
        set {
            if let token = newValue {
                LocalDataModel.save(token: token)
            }
        }
    }
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func login(user: String,
               password: String,
               onSuscces: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void)
    {
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
            onError(.malformeUrl)
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            onError(.dataFormating)
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        client.jwt(urlRequest) { [weak self] result in
            switch result {
            case let .success(token):
                self?.token = token
                onSuscces(token)
            case let .failure(error):
                onError(error)
            }
        }
    }
}

