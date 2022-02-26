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
        self.preferredSplitBehavior = .displace

        let bookListVC = BookListVC()
        let articleListVC = ArticleListVC()
        let mdDiplayVC = ParallelDisplayVC()

        let articleListNav = UINavigationController(rootViewController: articleListVC)
        let mdDisplayNav = UINavigationController(rootViewController: mdDiplayVC)

        setViewController(bookListVC, for: .primary)
        setViewController(articleListNav, for: .supplementary)
        setViewController(mdDisplayNav, for: .secondary)

        preferredPrimaryColumnWidthFraction = 1/3
        preferredSupplementaryColumnWidthFraction = 1/3
        showsSecondaryOnlyButton = true
        hide(.primary)

//        let test = UIView(frame: CGRect(x: 400, y: 400, width: 100, height: 100))
//        test.backgroundColor = .red
//        view.addSubview(test)

        let compactText = CompactTextVC()
        setViewController(compactText, for: .compact)
    }
}
