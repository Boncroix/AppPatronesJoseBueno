//
//  UseCaseTest.swift
//  DragonBallMVVMTests
//
//  Created by Jose Bueno Cruz on 28/1/24.
//

import XCTest
@testable import DragonBallMVVM

final class UseCaseTest: XCTestCase {
    private var sut: LoginUseCase!
    private var expectedToken = "token"
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let client = APIClient(session: session)
        sut = LoginUseCase(client: client)
        expectedToken = "token"
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        expectedToken = ""
    }
    func test_heroesUseCase() throws {
        
    }
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
        sut.login(user: user, password: password) { token in
            receivedToken = token
            expectation.fulfill()
        } onError: { networkError in
            XCTFail("Expected success but received \(networkError)")
            return
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedToken)
        XCTAssertEqual(receivedToken, expectedToken)
    }
}
