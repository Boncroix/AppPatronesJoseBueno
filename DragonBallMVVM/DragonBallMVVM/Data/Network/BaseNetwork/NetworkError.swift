//
//  NetworkError.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation

enum NetworkError: Error {
    case malformeUrl
    case dataFormating
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
    case encoding
    case other
}
