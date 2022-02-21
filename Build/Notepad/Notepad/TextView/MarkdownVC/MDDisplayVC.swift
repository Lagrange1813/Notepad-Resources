//
//  MDDisplayVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/21.
//

import SnapKit
import UIKit

class MDDisplayVC: UIViewController {
    var currentTextVC: CurrentTextVC!
    var mdPreviewVC: MDPreviewVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        splitViewController?.hide(.supplementary)
        
        currentTextVC = CurrentTextVC()
        currentTextVC.showCounter = false
        addChild(currentTextVC)
        view.addSubview(currentTextVC.view)
        currentTextVC.view.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
        
        mdPreviewVC = MDPreviewVC()
        addChild(mdPreviewVC)
        view.addSubview(mdPreviewVC.view)
        mdPreviewVC.view.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
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
