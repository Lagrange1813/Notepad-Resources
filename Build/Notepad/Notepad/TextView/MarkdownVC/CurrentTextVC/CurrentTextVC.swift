//
//  CurrentTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import UIKit

class CurrentTextVC: CommonTextVC {
    weak var mdDisplayVC: MDDisplayVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let articleField = articleField else { return }
        mdDisplayVC.synchronizedTitle = articleField.title!
        mdDisplayVC.synchronizedBody = articleField.body!
    }
}
