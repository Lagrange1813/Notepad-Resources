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

        textTheme = Theme.BuiltIn.TextLightFrostedGlass.enable()
        markdownTheme = Theme.BuiltIn.MarkdownLight.enable()
        loadTheme()
        
        navigationController?.navigationBar.isHidden = true

        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let textField = textField else { return }
        mdDisplayVC.synchronizedTitle = textField.title!
        mdDisplayVC.synchronizedBody = textField.body!
    }
}
