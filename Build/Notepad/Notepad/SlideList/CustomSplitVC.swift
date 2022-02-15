//
//  CustomSplitVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/14.
//

import UIKit

class CustomSplitVC: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        view.backgroundColor = .white
        self.preferredDisplayMode = .oneBesideSecondary
        
        let bookListVC = BookListVC()
        let articleListVC = ArticleListVC()
        let articleField = CurrentTextVC()
        
        let articleListNav = UINavigationController(rootViewController: articleListVC)
        let articleFieldNav = UINavigationController(rootViewController: articleField)
        
        setViewController(bookListVC, for: .primary)
        setViewController(articleListNav, for: .supplementary)
        setViewController(articleFieldNav, for: .secondary)
        
        preferredPrimaryColumnWidthFraction = 1/3
        preferredSupplementaryColumnWidthFraction = 1/3

        let bookListCompact = BookListVC()
        let bookListCompactNav = UINavigationController(rootViewController: bookListCompact)
        setViewController(bookListCompactNav, for: .compact)
    }

}
