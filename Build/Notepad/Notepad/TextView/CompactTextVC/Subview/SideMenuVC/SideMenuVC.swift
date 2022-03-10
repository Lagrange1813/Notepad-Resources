//
//  SideMenuVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

class SideMenuVC: UIViewController {
    let mainItems: [BookItem] = {
        let books = fetchBook()
        var objects: [BookItem] = []
        
        for book in books {
            objects.append(BookItem(title: book.title!, texts: { () -> [TextItem] in
                var texts: [TextItem] = []
                let textEntries = book.text!
                for text in textEntries {
                    texts.append(TextItem(title: (text as! Text).title!))
                }
                return texts
            }()))
        }
        
        return objects
    }()
    
//    func organizeItems() -> [BookItem] {
//        var objects: [BookItem] = []
//        for book in books {
//            objects.append(BookItem(title: book.title!, texts: { () -> [TextItem] in
//                var texts: [TextItem] = []
//                let textEntries = book.text!
//                for text in textEntries {
//                    texts.append(TextItem(title: (text as! Text).title!))
//                }
//                return texts
//            }()))
//        }
//        return objects
//    }
    
//    let modelObjects = [
//        BookItem(title: "白夜", texts: [
//            TextItem(title: "第一夜"),
//            TextItem(title: "第二夜"),
//            TextItem(title: "娜斯简卡的故事"),
//            TextItem(title: "第三夜"),
//            TextItem(title: "第四夜"),
//            TextItem(title: "早晨")
//        ]),
//        BookItem(title: "罪与罚", texts: [
//            TextItem(title: "第一章"),
//            TextItem(title: "第二章"),
//            TextItem(title: "第三章"),
//            TextItem(title: "第四章"),
//            TextItem(title: "第五章"),
//            TextItem(title: "第六章")
//        ])
//    ]
    
    enum Section {
        case sundry
        case main
    }
    
    var textList: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>!
    
    var theme: Theme!
    
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
        
        view.backgroundColor = .systemGray6
        
        configureCollectionView()
        configureDataSource()
        setupSnapshots()
    }
    
    func configureCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGray6
        configuration.headerMode = .firstItemInSection
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: configuration)

        textList = UICollectionView(frame: CGRect(), collectionViewLayout: listLayout)
        textList.tintColor = .black
        view.addSubview(textList)
        
        textList.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ScreenSize.topPadding!)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configureDataSource() {
        let sectionCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SectionItem> { cell, _, sectionItem in
            var content = cell.defaultContentConfiguration()
            content.text = sectionItem.title
            cell.contentConfiguration = content
            
            cell.accessories = [.outlineDisclosure()]
        }
        
        let bookCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, BookItem> { cell, _, bookItem in
            var content = cell.defaultContentConfiguration()
            content.text = bookItem.title
            content.image = bookItem.image
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        let textCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, TextItem> { cell, _, textItem in
            var content = cell.defaultContentConfiguration()
            content.image = textItem.image
            content.text = textItem.title
            cell.contentConfiguration = content
        }
        
        let blankCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, BlankItem> { cell, _, _ in
            let content = cell.defaultContentConfiguration()
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: textList) {
            collectionView, indexPath, listItem -> UICollectionViewCell? in
            
            switch listItem {
            case .section(let sectionItem):
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: sectionCellRegistration,
                                                                        for: indexPath,
                                                                        item: sectionItem)
                return cell
                
            case .book(let bookItem):
            
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: bookCellRegistration,
                                                                        for: indexPath,
                                                                        item: bookItem)
                var background = UIBackgroundConfiguration.listPlainCell()
                background.backgroundColor = .systemBackground
                cell.backgroundConfiguration = background
                
                return cell
            
            case .text(let textItem):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: textCellRegistration,
                                                                        for: indexPath,
                                                                        item: textItem)
                var background = UIBackgroundConfiguration.listPlainCell()
                background.backgroundColor = .systemBackground
                cell.backgroundConfiguration = background
                
                return cell
                
            case .blank(let blankItem):
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: blankCellRegistration,
                                                                        for: indexPath,
                                                                        item: blankItem)
                return cell
            }
        }
    }
    
    func setupSnapshots() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()

        // Create a section in the data source snapshot
        dataSourceSnapshot.appendSections([.sundry, .main])
        dataSource.apply(dataSourceSnapshot)
        
        // 杂项
        var sundrySectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        sundrySectionSnapshot.append([ListItem.blank(BlankItem())])
        sundrySectionSnapshot.append([ListItem.book(BookItem(title: "全部", image: "archivebox"))])
        sundrySectionSnapshot.append([ListItem.book(BookItem(title: "废纸篓",image: "trash"))])
        
        dataSource.apply(sundrySectionSnapshot, to: .sundry, animatingDifferences: false)
        
        // 书籍主列表
        var mainSectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        let bookSectionItem = ListItem.section(SectionItem(title: "书籍"))
        mainSectionSnapshot.append([bookSectionItem])
        mainSectionSnapshot.expand([bookSectionItem])
        
        for bookItem in mainItems {
            // Create a header ListItem & append as parent
            let bookListItem = ListItem.book(bookItem)
            mainSectionSnapshot.append([bookListItem], to: bookSectionItem)
            
            // Create an array of symbol ListItem & append as children of headerListItem
            let textListItemArray = bookItem.texts.map { ListItem.text($0) }
            mainSectionSnapshot.append(textListItemArray, to: bookListItem)
            
            // Expand this section by default
//            sectionSnapshot.expand([bookListItem])
        }
        
        dataSource.apply(mainSectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SideMenuVC: UICollectionViewDelegate {}
