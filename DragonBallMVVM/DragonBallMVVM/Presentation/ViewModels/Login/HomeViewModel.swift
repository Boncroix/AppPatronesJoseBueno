//
//  HomeViewModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Binding con UI
    var homeStatusLoad: ((GenericSatatusLoad) -> Void)?
    
    // MARK: - CaseUse
    let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Model
    var dataHeroes: [ModelDragonBall] = []
    
    // MARK: - Inits
    init(homeUseCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.homeUseCase = homeUseCase
    }
    
    func loadHeros() {
        homeStatusLoad?(.loading(true))
        
        homeUseCase.getHeros { [weak self] heroes in
            DispatchQueue.main.async {
                self?.dataHeroes = heroes
                self?.homeStatusLoad?(.loaded)
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
                self?.homeStatusLoad?(.errorNetwork(errorMessage))
            }
        }
    }
}
