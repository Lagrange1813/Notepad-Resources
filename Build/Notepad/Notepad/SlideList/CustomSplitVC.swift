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
        view.backgroundColor = .white
        self.preferredDisplayMode = .twoBesideSecondary
        self.preferredSplitBehavior = .tile

        let bookListVC = BookListVC()
        let articleListVC = ArticleListVC()
        let ParallelDisplayVC = ParallelDisplayVC()

        let articleListNav = UINavigationController(rootViewController: articleListVC)
        let ParallelDisplayNav = UINavigationController(rootViewController: ParallelDisplayVC)

        setViewController(bookListVC, for: .primary)
        setViewController(articleListNav, for: .supplementary)
        setViewController(ParallelDisplayNav, for: .secondary)

        preferredPrimaryColumnWidthFraction = 1/3
        preferredSupplementaryColumnWidthFraction = 1/3
        showsSecondaryOnlyButton = true
//        hide(.primary)

//        let test = UIView(frame: CGRect(x: 400, y: 400, width: 100, height: 100))
//        test.backgroundColor = .red
//        view.addSubview(test)

        compactText = CompactTextVC()
        setViewController(compactText, for: .compact)
    }
    
//    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
//        <#code#>
//    }
//
//    override func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
//
//    }
    
//    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
//        if column == .compact {
//            if let compactText = compactText {
//                compactText.view.removeFromSuperview()
//            }
//            compactText.restart()
//        }
//    }
    
//    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
//        compactText.restart()
//    }
    
//    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
//        if column == .compact {
//            compactText.restart()
//        }
//    }
}
