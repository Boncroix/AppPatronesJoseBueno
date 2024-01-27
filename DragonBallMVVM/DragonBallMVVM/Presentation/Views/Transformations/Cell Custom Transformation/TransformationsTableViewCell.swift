//
//  TransformationsTableViewCell.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 27/1/24.
//

import UIKit

final class TransformationsTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "TransformationsTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var transformationNameLabel: UILabel!
    @IBOutlet weak var transformationImage: UIImageView!
    
    // MARK: - Configure
    func configure(with transformation: ModelDragonBall) {
        transformationNameLabel.text = transformation.name
        guard let imageURL = URL(string: transformation.photo) else {
            return
        }
        transformationImage.setImage(url: imageURL)
    }
}
