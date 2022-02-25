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
            guard let textField = textField else { return }
            textField.titleView.text = titleString
        }
    }

    var bodyString: String = "" {
        didSet {
            guard let textField = textField else { return }
            textField.bodyView.text = bodyString
        }
    }

    var contentOffsetProportion: CGFloat = 0 {
        didSet {
            guard let textField = textField else { return }
            guard textField.contentSize.height > 0 else { return }
            textField.contentOffset.y = textField.contentSize.height * contentOffsetProportion
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTheme = Theme.BuiltIn.TextLightFrostedGlass.enable()
        markdownTheme = Theme.BuiltIn.MarkdownLight.enable()
        loadTheme()
        
        navigationController?.navigationBar.isHidden = true
        
        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
        saveText = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let textField = textField else { return }
        textField.titleView.isEditable = false
        textField.bodyView.isEditable = false
    }
}
