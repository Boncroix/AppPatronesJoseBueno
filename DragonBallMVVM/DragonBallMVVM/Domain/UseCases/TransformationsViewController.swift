//
//  TransformationsViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 27/1/24.
//

import UIKit

final class TransformationsViewController: UIViewController {
    
    // MARK: - Typealias
    typealias DataSource = UITableViewDiffableDataSource<Int, ModelDragonBall>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ModelDragonBall>
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Model
    private var transformations: [ModelDragonBall]
    private var dataSource: DataSource?
    
    // MARK: - Init
    init(transformations: [ModelDragonBall]) {
        self.transformations = transformations
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarWithLogout()
        setUpTableView()
        tableView.delegate = self
    }
}

// MARK: - Delegate
extension TransformationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Navegar al detaller de la transformación
    }
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        160
    }
}

// MARK: - setUp TableView
extension TransformationsViewController {
    func setUpTableView() {
        tableView.register(
            UINib(nibName: TransformationsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TransformationsTableViewCell.identifier
        )
    
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, transformations in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TransformationsTableViewCell.identifier,
                for: indexPath
            ) as? TransformationsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: transformations)
            return cell
        }
        
        tableView.dataSource = dataSource
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(transformations)
        dataSource?.apply(snapshot)
    }
}
