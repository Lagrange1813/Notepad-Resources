//
//  MDPreviewVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/21.
//

import UIKit

class MDPreviewVC: CommonTextVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
        saveText = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleField.titleView.isEditable = false
        articleField.bodyView.isEditable = false
    }
    
    
    
}
