//
//  Subtool.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/26.
//

import UIKit

class ToolBG: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) { return true }
        return super.touchesShouldCancel(in: view)
    }
}
