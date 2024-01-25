//
//  LocalDataModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 25/1/24.
//

import Foundation

import Foundation

struct LocalDataModel {
    private enum Constants {
        static let tokenKey = "KCToken"
    }
    
    private static let userDefaults = UserDefaults.standard
    
    static func getToken() -> String? {
        userDefaults.string(forKey: Constants.tokenKey)
    }
    
    static func save(token: String) {
        userDefaults.setValue(token, forKey: Constants.tokenKey)
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: Constants.tokenKey)
    }
}
