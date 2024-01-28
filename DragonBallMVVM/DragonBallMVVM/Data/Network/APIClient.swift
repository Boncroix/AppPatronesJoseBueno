//
//  APIClient.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 25/1/24.
//

import Foundation

// MARK: - Protocol
protocol APIClientProtocol {
    var session: URLSession { get }
    func request<T: Decodable>(
        _ request: URLRequest,
        using type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
}

// MARK: - AppClient
struct APIClient: APIClientProtocol {
    
    // MARK: - Session
    let session: URLSession
    
    // MARK: - Inits
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Request
    func request<T: Decodable>(
        _ request: URLRequest,
        using type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError>
            
            defer {
                completion(result)
            }
            guard error == nil else {
                result = .failure(.other)
                return
            }
            guard let data else {
                result = .failure(.noData)
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == HTTPResponseCodes.SUCCESS else {
                result = .failure(.errorCode(statusCode))
                return
            }
            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decoding)
                return
            }
            result = .success(resource)
        }
        .resume()
    }
    
    // MARK: - JsonWebTokens
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<String, NetworkError>
        
            defer {
                completion(result)
            }
            guard error == nil else {
                result = .failure(.other)
                return
            }
            guard let data else {
                result = .failure(.noData)
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == HTTPResponseCodes.SUCCESS else {
                result = .failure(.errorCode(statusCode))
                return
            }
            guard let jwt = String(data: data, encoding: .utf8) else {
                result = .failure(.decoding)
                return
            }
            result = .success(jwt)
        }
        .resume()
    }
}

