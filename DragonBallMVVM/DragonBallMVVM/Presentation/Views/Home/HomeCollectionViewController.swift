//
//  HomeCollectionViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import UIKit

class HomeCollectionViewController: UIViewController {
    
    // MARK: - Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ModelDragonBall>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ModelDragonBall>

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Model
    private var homeViewModel: HomeViewModel
    private var dataSource: DataSource?
    
    // MARK: - Inits
    init(homeViewModel: HomeViewModel = HomeViewModel()) {
        self.homeViewModel = homeViewModel
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
        homeViewModel.loadHeros()
        setObservers()
        collectionView.delegate = self
    }
    
    private func setObservers() {
        homeViewModel.homeStatusLoad = { [weak self] status in
            switch status {
            case .loading(_):
                print("Home Loading")
            case .loaded:
                DispatchQueue.main.async {
                    self?.setUpCollectionView()
                }
                
            case .errorNetwork(let error):
                print(error)
            default: break
            }
        }
    }
}


//MARK: - Extension Delegate
extension HomeCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DetailViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - setUp CollectionView
extension HomeCollectionViewController {
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns: CGFloat = (screenWidth > 600) ? 3 : 2
        let spacing: CGFloat = 8
        let totalSpacing = (numberOfColumns - 1) * spacing
        let itemWidth = (screenWidth - totalSpacing) / numberOfColumns
        
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
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
        var custonListHeroesData = self.homeViewModel.dataHeroes
        custonListHeroesData.removeAll { $0.name == "Quake (Daisy Johnson)"}
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(custonListHeroesData)
        self.dataSource?.apply(snapshot)
    }
}
