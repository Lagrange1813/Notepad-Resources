//
//  SideMenuVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

class SideMenuVC: UIViewController {
//    let books = fetchBook()
//    var bookList: [String] = []
//    var textList: [[Text]] = []
//
//    for x in 0 ..< books.count {
//        bookList.append(books[x].title!)
//        textList.append([])
//        let texts = books[x].text!
//        for text in texts {
//            textList[x].append(text as! Text)
//        }
//    }
//
//    var bookBoard: [UIMenuElement] = []
//
//    for x in 0 ..< bookList.count {
//        var textBoard: [UIAction] = []
//        for text in textList[x] {
//            let item = UIAction(title: text.title!, image: UIImage(systemName: "doc.text")) { _ in
//                UserDefaults.standard.set(text.id, forKey: "CurrentTextID")
//                self.restart()
//            }
//            textBoard.append(item)
//        }
//        let item = UIMenu(title: bookList[x], image: UIImage(systemName: "book.closed"), children: textBoard)
//        bookBoard.append(item)
//    }
    
    let modelObjects: [BookItem] = {
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
        case main
    }
    
    var textList: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>!
    var bookCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, BookItem>!
    var textCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, TextItem>!
    
    var theme: Theme!
    
    init(theme: Theme) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme.colorSet["background"]
        
        configureCollectionView()
        registerCell()
        configureDataSource()
        setupSnapshots()
    }
    
    func configureCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: configuration)

        textList = UICollectionView(frame: CGRect(), collectionViewLayout: listLayout)
        textList.tintColor = .systemYellow
        view.addSubview(textList)
        
        textList.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func registerCell() {
        bookCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, BookItem> { cell, _, bookItem in
            var content = cell.defaultContentConfiguration()
            content.text = bookItem.title
            content.image = bookItem.image
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        textCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, TextItem> { cell, _, textItem in
            var content = cell.defaultContentConfiguration()
//            content.image = textItem.image
            content.text = textItem.title
            cell.contentConfiguration = content
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: textList) {
            collectionView, indexPath, listItem -> UICollectionViewCell? in
            
            switch listItem {
            case .book(let bookItem):
            
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: self.bookCellRegistration,
                                                                        for: indexPath,
                                                                        item: bookItem)
                return cell
            
            case .text(let textItem):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: self.textCellRegistration,
                                                                        for: indexPath,
                                                                        item: textItem)
                return cell
            }
        }
    }
    
    func setupSnapshots() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()

        // Create a section in the data source snapshot
        dataSourceSnapshot.appendSections([.main])
        dataSource.apply(dataSourceSnapshot)
        
        // Create a section snapshot for main section
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        for bookItem in modelObjects {
            // Create a header ListItem & append as parent
            let bookListItem = ListItem.book(bookItem)
            sectionSnapshot.append([bookListItem])
            
            // Create an array of symbol ListItem & append as children of headerListItem
            let textListItemArray = bookItem.texts.map { ListItem.text($0) }
            sectionSnapshot.append(textListItemArray, to: bookListItem)
            
            // Expand this section by default
            sectionSnapshot.expand([bookListItem])
        }
        
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SideMenuVC: UICollectionViewDelegate {
    
}
