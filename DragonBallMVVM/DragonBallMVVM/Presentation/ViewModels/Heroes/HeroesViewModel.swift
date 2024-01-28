//
//  HeroesViewModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import Foundation

final class HeroesViewModel {
    
    // MARK: - Binding con UI
    var heroesStatusLoad: ((GenericSatatusLoad) -> Void)?
    
    // MARK: - CaseUse
    private let heroesUseCase: HeroesUseCaseProtocol
    
    // MARK: - Model
    var dataHeroes: [ModelDragonBall] = []
    
    // MARK: - Inits
    init(heroesUseCase: HeroesUseCaseProtocol = HeroesUseCase()) {
        self.heroesUseCase = heroesUseCase
    }
    
    // MARK: - Methods
    func loadHeros() {
        heroesStatusLoad?(.loading(true))
        
        heroesUseCase.getHeros(name: "") { [weak self] heroes in
            DispatchQueue.main.async {
                self?.dataHeroes = heroes
                self?.heroesStatusLoad?(.loaded)
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
                self?.heroesStatusLoad?(.errorNetwork(errorMessage))
            }
        }
    }
}
