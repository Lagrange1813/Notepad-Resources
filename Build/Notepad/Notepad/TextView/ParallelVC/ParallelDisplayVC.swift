//
//  MDDisplayVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/21.
//

import SnapKit
import UIKit

class ParallelDisplayVC: UIViewController {
    var currentTextVC: CurrentTextVC!
    var mdPreviewVC: MDPreviewVC!

    var synchronizedTitle: String = "" { didSet { mdPreviewVC.titleString = synchronizedTitle }}
    var synchronizedBody: String = "" { didSet { mdPreviewVC.bodyString = synchronizedBody }}
    var synchronizedProportion: CGFloat = 0 { didSet { mdPreviewVC.contentOffsetProportion = synchronizedProportion } }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        splitViewController?.hide(.supplementary)
        
        currentTextVC = CurrentTextVC()
        currentTextVC.showCounter = false
        addChild(currentTextVC)
        view.addSubview(currentTextVC.view)
        currentTextVC.parallelDisplayVC = self
        currentTextVC.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(0)
        }

        mdPreviewVC = MDPreviewVC()
        addChild(mdPreviewVC)
        view.addSubview(mdPreviewVC.view)
        mdPreviewVC.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentTextVC.view.snp.updateConstraints { make in
            make.width.equalTo(view.frame.width/2)
        }
        mdPreviewVC.view.snp.updateConstraints { make in
            make.width.equalTo(view.frame.width/2)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}
