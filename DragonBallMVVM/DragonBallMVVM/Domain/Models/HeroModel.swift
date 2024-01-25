//
//  HeroModel.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 25/1/24.
//

import Foundation

struct HeroModel: Codable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
}
