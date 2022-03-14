//
//  CustomBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import UIKit

class CustomBtn: UIButton {
    var argument: String?

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.tintColor = .white
            } else {
                self.tintColor = .black
            }
        }
    }

}
