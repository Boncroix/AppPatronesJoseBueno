//
//  UseCaseTest.swift
//  DragonBallMVVMTests
//
//  Created by Jose Bueno Cruz on 28/1/24.
//

import XCTest
@testable import DragonBallMVVM


final class UseCaseTest: XCTestCase {
    
    // MARK: Properties
    private var sutLoginUseCase: LoginUseCase!
    private var expectedToken = "token"
    
    private var sutHeroesUseCase: HeroesUseCase!
    private var expectedHero: String = ""
    
    private var sutTransformationsUseCase: TransformationsUseCase!
    private var expectedTransformation: String = ""
    
    // MARK: setUp
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let client = APIClient(session: session)
        sutLoginUseCase = LoginUseCase(client: client)
        expectedToken = "token"
        sutHeroesUseCase = HeroesUseCase(client: client)
        expectedHero = """
[
    {
        "description": "Krilin lo tiene todo. Cuando aún no existían los 'memes', Krilin ya los protagonizaba. Junto a Yamcha ha sido objeto de burla por sus desafortunadas batallas en Dragon Ball Z. Inicialmente, Krilin era el mejor amigo de Goku siendo sólo dos niños que querían aprender artes marciales. El Maestro Roshi les entrena para ser dos grandes luchadores, pero la diferencia entre ambos cada vez es más evidente. Krilin era ambicioso y se ablanda con el tiempo. Es un personaje que acepta un papel secundario para apoyar el éxito de su mejor amigo Goku de una forma totalmente altruista.",
        "favorite": true,
        "name": "Krilin",
        "id": "D88BE50B-913D-4EA8-AC42-04D3AF1434E3",
        "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300"
    }
]
"""
        sutTransformationsUseCase = TransformationsUseCase(client: client)
        expectedTransformation = """
[
    {
        "id": "CEC4FBF9-EF37-4773-A6AE-189DB2D92CE8",
        "hero": {
            "id": "D88BE50B-913D-4EA8-AC42-04D3AF1434E3"
        },
        "photo": "https://areajugones.sport.es/wp-content/uploads/2020/03/NoegoKrillin-1024x576.jpg.webp",
        "name": "1. No Ego",
        "description": "Esta transformación se introduce en Dragon Ball Super con el objetivo de volver a hacer al personaje algo más competitivo. Lo alcanza durante su entrenamiento con Goku en el Bosque del Terror. Krilin gana un nuevo poder al enfrentar sus miedos y controlar su corazón. El aura de Krilin no se dispersa como lo hace habitualmente, sino que toma forma alrededor de su cuerpo, evitando que nada de ki se desperdicie. En esta estado el personaje lucha más tarde contra Goku en SSB en una batalla que causó mucha polémica. A pesar de que se presentó como posible, en este estado el personaje sigue muy lejos de los niveles de poder del Saiyan."
    }
]
"""
    }
    // MARK: - TearDown
    override func tearDown() {
        super.tearDown()
        sutLoginUseCase = nil
        expectedToken = ""
        sutHeroesUseCase = nil
        expectedHero = ""
        sutTransformationsUseCase = nil
        expectedTransformation = ""
    }
    
    // MARK: - Test transformationsUseCase
    func test_transformationsUseCase() throws {
        // Given
        let responseData = try XCTUnwrap(expectedTransformation.data(using: .utf8))
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, HTTPMethods.post)
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(self.expectedToken)")
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: EndPoints.url.rawValue)!,
                    statusCode: HTTPResponseCodes.SUCCESS,
                    httpVersion: nil,
                    headerFields: ["Content-Type": HTTPMethods.contenType])
            )
            return (response, responseData)
        }
        
        // When
        let expectation = expectation(description: "Get Model Success")
        var receivedTransformation: [ModelDragonBall]?
        sutTransformationsUseCase.getTransformations(id: "") { transformation in
            receivedTransformation = transformation
            expectation.fulfill()
        } onError: { networkError in
            XCTFail("No ModelsDragonBall received \(networkError)")
            return
        }

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(receivedTransformation)
        XCTAssertEqual(receivedTransformation?[0].name ?? "", "1. No Ego")
        XCTAssertEqual(receivedTransformation?[0].id ?? "", "CEC4FBF9-EF37-4773-A6AE-189DB2D92CE8")
    }

    // MARK: - Test heroesUseCase
    func test_heroesUseCase() throws {
        // Given
        let responseData = try XCTUnwrap(expectedHero.data(using: .utf8))
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, HTTPMethods.post)
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(self.expectedToken)")
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: EndPoints.url.rawValue)!,
                    statusCode: HTTPResponseCodes.SUCCESS,
                    httpVersion: nil,
                    headerFields: ["Content-Type": HTTPMethods.contenType])
            )
            return (response, responseData)
        }
        
        // When
        let expectation = expectation(description: "Get Model Success")
        var receivedModelDragonBall: [ModelDragonBall]?
        sutHeroesUseCase.getHeros (name: ""){ hero in
            receivedModelDragonBall = hero
            expectation.fulfill()
        } onError: { networkError in
            XCTFail("No ModelsDragonBall received \(networkError)")
            return
        }
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(receivedModelDragonBall)
        XCTAssertEqual(receivedModelDragonBall?[0].name ?? "", "Krilin")
        XCTAssertEqual(receivedModelDragonBall?[0].id ?? "", "D88BE50B-913D-4EA8-AC42-04D3AF1434E3")
    }
    
    // MARK: - Test loginUseCase
    func test_loginUseCase() throws {
        // Given
        let tokenData = try XCTUnwrap(expectedToken.data(using: .utf8))
        let (user, password) = ("user", "password")
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", user, password)
            let base64String = loginString.data(using: .utf8)!.base64EncodedString()
            XCTAssertEqual(request.httpMethod, HTTPMethods.post)
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Basic \(base64String)")
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: EndPoints.url.rawValue)!,
                    statusCode: HTTPResponseCodes.SUCCESS,
                    httpVersion: nil,
                    headerFields: ["Content-Type": HTTPMethods.contenType])
            )
            return (response, tokenData)
        }
        
        // When
        let expectation = expectation(description: "Login Success")
        var receivedToken: String?
        sutLoginUseCase.login(user: user, password: password) { token in
            receivedToken = token
            expectation.fulfill()
        } onError: { networkError in
            XCTFail("Expected success but received \(networkError)")
            return
        }
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(receivedToken)
        XCTAssertEqual(receivedToken, expectedToken)
    }
}

