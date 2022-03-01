//
//  CustomSplitVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/14.
//

import UIKit

class CustomSplitVC: UISplitViewController, UISplitViewControllerDelegate {
    var compactText: CompactTextVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.restorationIdentifier = "MainView"
        view.backgroundColor = .white
        self.preferredDisplayMode = .twoOverSecondary
        self.preferredSplitBehavior = .displace

        let bookListVC = BookListVC()
        let articleListVC = ArticleListVC()
        let parallelDisplayVC = ParallelDisplayVC()

        let articleListNav = UINavigationController(rootViewController: articleListVC)
        let parallelDisplayNav = UINavigationController(rootViewController: parallelDisplayVC)
        
//        bookListVC.restorationIdentifier = "BookListView"
//        articleListVC.restorationIdentifier = "ArticleListView"
//        parallelDisplayVC.restorationIdentifier = "ParallelView"
//        
//        articleListNav.restorationIdentifier = "ArticleListNav"
//        parallelDisplayNav.restorationIdentifier = "ParallelNav"

        setViewController(bookListVC, for: .primary)
        setViewController(articleListNav, for: .supplementary)
        setViewController(parallelDisplayNav, for: .secondary)

        preferredPrimaryColumnWidthFraction = 1/3
        preferredSupplementaryColumnWidthFraction = 1/3
        showsSecondaryOnlyButton = true
//        hide(.primary)

//        let test = UIView(frame: CGRect(x: 400, y: 400, width: 100, height: 100))
//        test.backgroundColor = .red
//        view.addSubview(test)

        compactText = CompactTextVC()
        compactText.restorationIdentifier = "CompactView"
        setViewController(compactText, for: .compact)
    }
    
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        if let compactText = compactText {
//            compactText.view.removeFromSuperview()
            compactText.remove()

        }
    }
}
