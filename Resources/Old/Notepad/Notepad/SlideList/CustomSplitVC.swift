//
//  CustomSplitVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/14.
//

import UIKit

class CustomSplitVC: UISplitViewController, UISplitViewControllerDelegate {
    var compactView: CompactTextVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        restorationIdentifier = "MainView"
        view.backgroundColor = .white
        preferredDisplayMode = .twoOverSecondary
        preferredSplitBehavior = .displace

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

        preferredPrimaryColumnWidthFraction = 1 / 3
        preferredSupplementaryColumnWidthFraction = 1 / 3
        showsSecondaryOnlyButton = true
//        hide(.primary)

//        let test = UIView(frame: CGRect(x: 400, y: 400, width: 100, height: 100))
//        test.backgroundColor = .red
//        view.addSubview(test)

        compactView = CompactTextVC()
//        compactView.restorationIdentifier = "CompactView"
        let compactViewNav = UINavigationController(rootViewController: compactView)
        setViewController(compactViewNav, for: .compact)
    }

    func splitViewController(_: UISplitViewController, willShow _: UISplitViewController.Column) {
        if let compactView = compactView {
//            compactText.view.removeFromSuperview()
            compactView.remove()
        }
    }
}
