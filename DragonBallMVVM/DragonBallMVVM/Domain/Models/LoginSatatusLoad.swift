//
//  LoginSatatusLoad.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import Foundation

enum LoginSatatusLoad {
    case loading(_ isLoading: Bool)
    case loaded
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case errorNetwor(_ error: String)
}
