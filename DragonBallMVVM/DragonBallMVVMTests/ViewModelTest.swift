//
//  ViewModelTest.swift
//  DragonBallMVVMTests
//
//  Created by Jose Bueno Cruz on 28/1/24.
//

import XCTest

final class ViewModelTest: XCTestCase {
    
    // MARK: - Test LoginViewModel Fake Success
    func test_LoginViewModelFakeSuccess() throws {
        let expectation = self.expectation(description: "Expect token")
        let sut = LoginViewModel(loginUseCase: LoginUseCaseFakeSuccess())
        XCTAssertNotNil(sut)
        sut.loginViewState = { status in
            switch status {
            case .loaded:
                expectation.fulfill()
            default: break
            }
        }
        sut.onLoginButton(email: "prueba@", password: "password")
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test LoginViewModel Fake Error
    func test_LoginViewModelFakeError() throws {
        let expectation = self.expectation(description: "Expect Error")
        let sut = LoginViewModel(loginUseCase: LoginUseCaseFakeError())
        XCTAssertNotNil(sut)
        sut.loginViewState = { status in
            switch status {
            case .errorNetwork(_):
                expectation.fulfill()
            default: break
            }
        }
        sut.onLoginButton(email: "prueba@", password: "password")
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test HeroesViewModel Fake Success
    func test_HeroesViewModelFakeSuccess() throws {
        let expectation = self.expectation(description: "Expect Heroes")
        let sut = HeroesViewModel(heroesUseCase: HeroesUseCaseFakeSuccess())
        XCTAssertNotNil(sut)
        sut.heroesStatusLoad = { status in
            switch status {
            case .loaded:
                expectation.fulfill()
            default: break
            }
        }
        sut.loadHeros()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test HeroesViewModel Fake Error
    func test_HeroesViewModelFakeError() throws {
        let expectation = self.expectation(description: "Expect Error")
        let sut = HeroesViewModel(heroesUseCase: HeroesUseCaseFakeError())
        XCTAssertNotNil(sut)
        sut.heroesStatusLoad = { status in
            switch status {
            case .errorNetwork(_):
                expectation.fulfill()
            default: break
            }
        }
        sut.loadHeros()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test TransformationsViewModel Fake Success
    func test_TransformationsViewModelFakeSuccess() throws {
        let expectation = self.expectation(description: "Expect Transformations")
        let sut = TransformationsViewModel(transformationsUseCase: TransformationsUseCaseFakeSuccess())
        XCTAssertNotNil(sut)
        sut.transformationsStatusLoad = { status in
            switch status {
            case .loaded:
                expectation.fulfill()
            default: break
            }
        }
        sut.loadTransformations(id: "")
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Test TransformationsViewModel Fake Error
    func test_TransformationsViewModelFakeError() throws {
        let expectation = self.expectation(description: "Expect Error")
        let sut = TransformationsViewModel(transformationsUseCase: TramsformationsUseCaseFakeError())
        XCTAssertNotNil(sut)
        sut.transformationsStatusLoad = { status in
            switch status {
            case .errorNetwork(_):
                expectation.fulfill()
            default: break
            }
        }
        sut.loadTransformations(id: "")
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Fake Success LoginViewModel
final class LoginUseCaseFakeSuccess: LoginUseCaseProtocol {
    func login(user: String,
               password: String,
               onSuscces: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let token = "token"
            onSuscces(token)
        }
    }
}

// MARK: - Fake Error LoginViewModel
final class LoginUseCaseFakeError: LoginUseCaseProtocol {
    func login(user: String,
               password: String,
               onSuscces: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(NetworkError.tokenFormatError)
        }
    }
}

// MARK: - Fake Success HeroesViewModel
final class HeroesUseCaseFakeSuccess: HeroesUseCaseProtocol {
    func getHeros(name: String, 
                  onSuccess: @escaping ([ModelDragonBall]) -> Void,
                  onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let heroes = [ModelDragonBall(id: "1", name: "Aitor", description: "Superman", photo: ""),
                          ModelDragonBall(id: "2", name: "Jose", description: "Spiderman", photo: ""),
                          ModelDragonBall(id: "3", name: "Paco", description: "Cat Woman", photo: "")]
            
            onSuccess(heroes)
        }
    }
}

// MARK: - Fake Error HeroesViewModel
final class HeroesUseCaseFakeError: HeroesUseCaseProtocol {
    func getHeros(name: String, 
                  onSuccess: @escaping ([ModelDragonBall]) -> Void,
                  onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(NetworkError.other)
        }
    }
}

// MARK: - Fake Success TransformationsViewModel
final class TransformationsUseCaseFakeSuccess: TransformationsUseCaseProtocol {
    func getTransformations(id: String, 
                            onSuccess: @escaping ([ModelDragonBall]) -> Void,
                            onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let transformations = [ModelDragonBall(id: "1", name: "Aitor", description: "Superman", photo: ""),
                          ModelDragonBall(id: "2", name: "Jose", description: "Spiderman", photo: ""),
                          ModelDragonBall(id: "3", name: "Paco", description: "Cat Woman", photo: "")]
            
            onSuccess(transformations)
        }
    }
}

// MARK: - Fake Error TransformationsViewModel
final class TramsformationsUseCaseFakeError: TransformationsUseCaseProtocol {
    func getTransformations(id: String, 
                            onSuccess: @escaping ([ModelDragonBall]) -> Void,
                            onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onError(NetworkError.other)
        }
    }
}

    
