//
//  SideMenuVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

class SideMenuVC: UIViewController {
    var theme: Theme!
    var textList: UICollectionView!
    
    private enum Section: CaseIterable {
        case main
    }
    
    var books = [BookCell]() {
        didSet {
            
        }
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, BookCell> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, BookCell> { cell, _, country in
            var content = cell.defaultContentConfiguration()
            content.text = country.name

            content.image = UIImage(systemName: "globe")
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

            cell.contentConfiguration = content

            cell.accessories = [.disclosureIndicator()]
            cell.tintColor = .systemPurple
        }

        return UICollectionViewDiffableDataSource<Section, BookCell>(collectionView: collectionView) { (collectionView, indexPath, country) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: country)
        }
    }()
    
    init(theme: Theme) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.colorSet["background"]
        
        textList = UICollectionView()
        createLayout()
        applySnapshot(animatingDifferences: false)
    }
    
    private func createLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        textList.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BookCell>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    
    
    
}

extension SideMenuVC: UICollectionViewDelegate {
    
}
