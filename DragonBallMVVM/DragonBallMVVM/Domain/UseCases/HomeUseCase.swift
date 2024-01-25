//
//  HomeUseCase.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 25/1/24.
//

import Foundation

protocol HomeUseCaseProtocol {
    func getHeros(onSuccess: @escaping ([HeroModel]) -> Void,
                  onError: @escaping (NetworkError) -> Void)
}

final class HomeUseCase: HomeUseCaseProtocol {
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func getHeros(onSuccess: @escaping ([HeroModel]) -> Void,
                  onError: @escaping (NetworkError) -> Void) {
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allHeros.rawValue)") else {
            onError(.malformeUrl)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post
        // TODO: - Obtener el token de algún sitio
        urlRequest.setValue("Bearer \("token")", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(HTTPMethods.contenType, forHTTPHeaderField: "Content-Type")
        
        struct HeroRequest: Codable {
            let name: String
        }
        
        let heroRequest = HeroRequest(name: "")
        urlRequest.httpBody = try? JSONEncoder().encode(heroRequest)
        
        client.request(urlRequest, using: [HeroModel].self) { result in
            switch result {
            case let .success(dataHeroes):
                onSuccess(dataHeroes)
            case let .failure(error):
                onError(error)
            }
        }
        
    }
}


// MARK: - Fake Success
final class HomeUseCaseFakeSuccess: HomeUseCaseProtocol {
    func getHeros(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let heroes = [HeroModel(id: "1", name: "Aitor", description: "Superman", photo: "", favorite: true),
            HeroModel(id: "2", name: "José", description: "Spiderman", photo: "", favorite: false),
            HeroModel(id: "3", name: "Dolores", description: "Cat Woman", photo: "", favorite: true)]
            
            onSuccess(heroes)
        }
    }
}

// MARK: - Fake Error
final class HomeUseCaseFakeError: HomeUseCaseProtocol {
    func getHeros(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(.noData)
        }
    }
}
