//
//  DetailViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var heroTransformationsButton: UIButton!
    
    // MARK: - Model
    private var hero: ModelDragonBall
    
    // MARK: - Initializer
    init(hero: ModelDragonBall) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions
    @IBAction func didTapTransformationsButton(_ sender: Any) {
    }
    
    // MARK: - Configure
    func configure() {
        setupNavigationBarWithLogout()
        heroNameLabel.text = hero.name
        heroDescription.text = hero.description
        guard let imageURL = URL(string: hero.photo) else {
            return
        }
        heroImage.setImage(url: imageURL)
    }
}

