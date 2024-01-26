//
//  HeroCollectionViewCell.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    // MARK: - Identifier
    static let identifier = "HeroCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    // MARK: - Configure
    func configure(with hero: ModelDragonBall) {
        heroNameLabel.text = hero.name
        guard let imageURL = URL(string: hero.photo) else {
            return
        }
        heroImage.setImage(url: imageURL)
    }
}
