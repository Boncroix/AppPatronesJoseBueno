//
//  DetailViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var heroTransformationsButton: UIButton!
    
    // MARK: - Model
    private var hero: ModelDragonBall
    private var transformationsViewModel: TransformationsViewModel
    
    // MARK: - Init
    init(hero: ModelDragonBall,
         transformationsViewModel : TransformationsViewModel = TransformationsViewModel()) {
        self.hero = hero
        self.transformationsViewModel = transformationsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        transformationsViewModel.loadTransformations(id: hero.id)
        setObservers()
        configure()
    }
    
    private func setObservers() {
        transformationsViewModel.transformationsStatusLoad = { [weak self] status in
            switch status {
            case .loading(_):
                print("Transformations Loading")
            case .loaded:
                self?.checkTransformations()
            case .errorNetwork(let error):
                print(error)
            default: break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapTransformationsButton(_ sender: Any) {
        var customListTransformations = transformationsViewModel.dataTransformations
        customListTransformations.sort {
            let numero1 = Int($0.name.components(separatedBy: ".").first ?? "") ?? 0
            let numero2 = Int($1.name.components(separatedBy: ".").first ?? "") ?? 0
            return numero1 < numero2
        }
        let nextVC = TransformationsViewController(transformations: customListTransformations)
        navigationController?.pushViewController(nextVC, animated: true)
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
    
    func checkTransformations() {
        heroTransformationsButton.isHidden = transformationsViewModel.dataTransformations.isEmpty
    }
}

