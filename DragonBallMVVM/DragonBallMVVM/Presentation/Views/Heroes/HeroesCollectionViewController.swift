//
//  HeroesCollectionViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 27/1/24.
//

import UIKit

final class HeroesCollectionViewController: UIViewController {
    
    // MARK: - Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ModelDragonBall>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ModelDragonBall>

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var heroesViewModel: HeroesViewModel
    private var dataSource: DataSource?
    
    // MARK: - Inits
    init(heroesViewModel: HeroesViewModel = HeroesViewModel()) {
        self.heroesViewModel = heroesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarWithLogout()
        heroesViewModel.loadHeros()
        setObservers()
        collectionView.delegate = self
    }
}

// MARK: - Observers
extension HeroesCollectionViewController {
    private func setObservers() {
        heroesViewModel.heroesStatusLoad = { [weak self] status in
            switch status {
            case .loading(_):
                print("Heroes Loading")
            case .loaded:
                self?.setUpCollectionView()
            case .errorNetwork(let error):
                print(error)
            default: break
            }
        }
    }
}
// MARK: - Delegate
extension HeroesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = heroesViewModel.dataHeroes[indexPath.row]
        let nextVC = DetailViewController(hero: hero)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - setUp CollectionView
extension HeroesCollectionViewController {
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 190, height: 200)
        collectionView.collectionViewLayout = layout
        
        let registration = UICollectionView.CellRegistration<
            HeroCollectionViewCell,
            ModelDragonBall
        >(
            cellNib: UINib(
                nibName: HeroCollectionViewCell.identifier,
                bundle: nil
            )
        ) { cell, _, hero in
            cell.configure(with: hero)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: hero
            )
        }
        
        collectionView.dataSource = dataSource
        
        DispatchQueue.main.async {
            var custonListHeroesData = self.heroesViewModel.dataHeroes
            custonListHeroesData.removeAll { $0.name == "Quake (Daisy Johnson)"}
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(custonListHeroesData)
            self.dataSource?.apply(snapshot)
        }
    }
}

