//
//  ControllerFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/11.
//

import CoreData
import SnapKit
import UIKit

extension CompactTextVC {
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
        case textField
        case bodyView
    }

    func correctCoordinates(_ location: CGFloat, position: Position) -> CGFloat {
        guard let textField = textField else { return 0 }
        let viewCoordinates = textField.contentOffset
        switch position {
        case .view:
            return location - ScreenSize.topPadding!
        case .textField:
            return location - viewCoordinates.y
        case .bodyView:
            let temp = location + textField.titleView.bounds.height - viewCoordinates.y
            return temp
        }
    }

    func updateViewWidth() {
        viewWidth = view.frame.width
    }

    func updateComponents() {
        let width = viewWidth - 10
        titleBar.frame.size.width = width
        titleBar.frame.origin.x = view.frame.width/2 - width/2

        toolBar.viewWidth = viewWidth
        toolBar.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
        toolBar.updateScrollToolView()
    }
}
