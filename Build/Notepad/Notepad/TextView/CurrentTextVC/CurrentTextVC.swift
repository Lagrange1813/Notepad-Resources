//
//  CurrentTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

class CurrentTextVC: CommonTextVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        barHeight = 0
        topPadding = 0
        bottomPadding = view.frame.height / 2
        
    }
}
