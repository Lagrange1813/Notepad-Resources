//
//  ControllerFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/11.
//

import UIKit
import SnapKit
import CoreData

extension CurrentTextVC {
    func showTitleBar() {
        UIView.animate(withDuration: 0.7, animations: {
            self.titleBar.frame.origin.y = ScreenSize.topPadding! + titleBarOffset
        })
    }
    
    func hideTitleBar() {
        UIView.animate(withDuration: 0.7, animations: {
            self.titleBar.frame.origin.y -= (TitleBar.height() + titleBarOffset + 5)
        })
    }
    
    enum Position {
        case view
        case articleField
        case bodyView
    }
    
    func correctCoordinates(_ location: CGFloat, position: Position) -> CGFloat {
        let viewCoordinates = articleField.contentOffset
        switch position {
        case .view:
            return location - ScreenSize.topPadding!
        case .articleField:
            return location - viewCoordinates.y
        case .bodyView:
            let temp = location + articleField.titleView.bounds.height - viewCoordinates.y
            return temp
        }
    }
}
