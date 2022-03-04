//
//  SideMenuVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

class SideMenuVC: UIViewController {
    var theme: Theme!
    
    init(theme: Theme) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.colorSet["background"]
    }
}
