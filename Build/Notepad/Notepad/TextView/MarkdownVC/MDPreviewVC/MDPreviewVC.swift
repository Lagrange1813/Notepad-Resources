//
//  MDPreviewVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/21.
//

import UIKit

class MDPreviewVC: CommonTextVC {
    var titleString: String = "" {
        didSet {
            guard let articleField = articleField else { return }
            articleField.titleView.text = titleString
        }
    }

    var bodyString: String = "" {
        didSet {
            guard let articleField = articleField else { return }
            articleField.bodyView.text = bodyString
        }
    }

    var contentOffsetProportion: CGFloat = 0 {
        didSet {
            guard let articleField = articleField else { return }
            guard articleField.contentSize.height > 0 else { return }
            articleField.contentOffset.y = articleField.contentSize.height * contentOffsetProportion
        }
    }

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
        
        guard let articleField = articleField else { return }
        articleField.titleView.isEditable = false
        articleField.bodyView.isEditable = false
    }
}
