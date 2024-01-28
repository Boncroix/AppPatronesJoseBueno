//
//  LoginUseCase.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation

// MARK: - Protocol
protocol LoginUseCaseProtocol {
    func login(user: String,
               password: String,
               onSuscces: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    
    // MARK: - Client
    private let client: APIClientProtocol
    
    // MARK: - Inits
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    // MARK: - Methods
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
        
        client.jwt(urlRequest) { result in
            switch result {
            case let .success(token):
                UserDefaultsHelper.save(token: token)
                onSuscces(token)
            case let .failure(error):
                onError(error)
            }
        }
    }
}

