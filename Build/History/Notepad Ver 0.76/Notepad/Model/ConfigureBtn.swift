//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CurrentTextVC {
    func configureBtnAction() {
        
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)
    }
    
    @objc func downBtnFunc() {
        print("down")
        self.resignFirstResponder()
    }
}
