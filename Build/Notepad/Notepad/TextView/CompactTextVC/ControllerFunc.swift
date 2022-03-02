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
        UIView.animate(withDuration: 0.5, animations: {
            self.titleBar.frame.origin.y -= (TitleBar.height() + titleBarOffset + 5 + ScreenSize.topPadding!)
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
    
    func restart() {
        remove()
        
        loadData()
        loadInfo()
        loadTheme()
        if theme.frostedGlass {
            configureBackgroundImage()
            configureBlur()
        } else {
            view.backgroundColor = theme.colorSet["background"]
        }
        loadTextView()
        configureTextView()
        if showCounter {
            configureCounter()
        }
        configureToolBar()
        configureTitleBar()

        registNotification()

        configureTitleBarBtnAction()
        configureToolBarBtnAction()
    }
    
    func remove() {
        guard let textField = textField else { return }
        
        textField.removeFromSuperview()
        self.textField = nil
        counter.removeFromSuperview()
        counter = nil
        titleBar.removeFromSuperview()
        titleBar = nil
        toolBar.removeFromSuperview()
        toolBar = nil
        image?.removeFromSuperview()
        image = nil
        backgroundSupport?.removeFromSuperview()
        backgroundSupport = nil
    }
}
