//
//  CurrentTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import UIKit

class CurrentTextVC: CommonTextVC {
    weak var parallelDisplayVC: ParallelDisplayVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textTheme = Theme.BuiltIn.TextLightFrostedGlass.enable()
        markdownTheme = Theme.BuiltIn.MarkdownLight.enable()
        loadTheme()

        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let textField = textField else { return }
        parallelDisplayVC.synchronizedTitle = textField.title!
        parallelDisplayVC.synchronizedBody = textField.body!
    }
}
