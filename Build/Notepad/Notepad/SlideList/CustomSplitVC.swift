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
        self.preferredDisplayMode = .twoDisplaceSecondary
        self.preferredSplitBehavior = .displace
        
        let bookListVC = BookListVC()
        let articleListVC = ArticleListVC()
        let currentTextVC = CurrentTextVC()
        
        let articleListNav = UINavigationController(rootViewController: articleListVC)
        let currentTextNav = UINavigationController(rootViewController: currentTextVC)
        
        setViewController(bookListVC, for: .primary)
        setViewController(articleListNav, for: .supplementary)
        setViewController(currentTextNav, for: .secondary)
        
        preferredPrimaryColumnWidthFraction = 1/3
        preferredSupplementaryColumnWidthFraction = 1/3
        showsSecondaryOnlyButton = true
        hide(.primary)

        let articleCompact = ArticleTextVC()
        setViewController(articleCompact, for: .compact)
        
        
    }

}
