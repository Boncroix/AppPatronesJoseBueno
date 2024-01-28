//
//  TransformationsViewModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 27/1/24.
//

import Foundation

final class TransformationsViewModel {
    
    // MARK: - Binding con UI
    var transformationsStatusLoad: ((GenericSatatusLoad) -> Void)?
    
    // MARK: - CaseUse
    let transformationsUseCase: TransformationsUseCaseProtocol
    
    // MARK: - Model
    var dataTransformations: [ModelDragonBall] = []
    
    // MARK: - Inits
    init(transformationsUseCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.transformationsUseCase = transformationsUseCase
    }
    
    // MARK: - Methods
    func loadTransformations(id: String) {
        transformationsStatusLoad?(.loading(true))
        transformationsUseCase.getTransformations(id: id) { [weak self] transformations in
            DispatchQueue.main.async {
                self?.dataTransformations = transformations
                self?.transformationsStatusLoad?(.loaded)
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
                self?.transformationsStatusLoad?(.errorNetwork(errorMessage))
            }
        }
    }
}
