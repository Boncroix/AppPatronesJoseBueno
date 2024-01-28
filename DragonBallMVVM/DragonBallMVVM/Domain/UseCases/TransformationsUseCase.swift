//
//  TransformationsUseCase.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 27/1/24.
//

import Foundation

// MARK: - Protocol
protocol TransformationsUseCaseProtocol {
    func getTransformations(id: String,
                            onSuccess: @escaping ([ModelDragonBall]) -> Void,
                            onError: @escaping (NetworkError) -> Void)
}

final class TransformationsUseCase: TransformationsUseCaseProtocol {
    
    // MARK: - Client
    private let client: APIClientProtocol
    
    // MARK: - Inits
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    // MARK: - Methods
    func getTransformations(id: String,
                            onSuccess: @escaping ([ModelDragonBall]) -> Void,
                            onError: @escaping (NetworkError) -> Void) {
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.transformationsHeros.rawValue)") else {
            onError(.malformeUrl)
            return
        }
        guard let token = UserDefaultsHelper.getToken() else {
            onError(.tokenFormatError)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(HTTPMethods.contenType, forHTTPHeaderField: "Content-Type")
        
        struct TransformationsRequest: Codable {
            let id: String
        }
        let transformationsRequest = TransformationsRequest(id: id)
        urlRequest.httpBody = try? JSONEncoder().encode(transformationsRequest)
        
        client.request(urlRequest, using: [ModelDragonBall].self) { result in
            switch result {
            case let .success(dataTransformations):
                onSuccess(dataTransformations)
            case let .failure(error):
                onError(error)
            }
        }
    }
}
