//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CompactTextVC {
    // MARK: - Title bar button configurment

    func configureTitleBarBtnAction() {
        titleBar.listBtn.addTarget(self, action: #selector(listBtnFunc), for: .touchUpInside)
        titleBar.typeBtn.addTarget(self, action: #selector(typeBtnFunc), for: .touchUpInside)
    }

    @objc func listBtnFunc() {
        saveData(title: "Test", body: "iahuohihoifbuiauihuuifba", type: "MD")
        restart()
    }
    
    @objc func typeBtnFunc() {
        let titleToStore: String = textField.titleView.text
        let bodyToStore: String = textField.bodyView.text

        saveData(title: titleToStore, body: bodyToStore, type: {
            switch type {
            case "Text": return "MD"
            case "MD": return "Text"
            default: return ""
            }
        }())
        restart()
    }

    // MARK: - Tool bar button configurment

    func configureToolBarBtnAction() {
        toolBar.commandBtn.addTarget(self, action: #selector(commandBtnFunc), for: .touchUpInside)

        toolBar.undoBtn.addTarget(self, action: #selector(undoFunc), for: .touchUpInside)
        
        toolBar.pasteBtn.addTarget(self, action: #selector(pasteBtnFunc), for: .touchUpInside)
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)
        
        configureShortCutTouchPadHandler()

        toolBar.redoBtn?.addTarget(self, action: #selector(redoFunc), for: .touchUpInside)
        
        toolBar.quotesBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.sqrBracketsBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.bracketsBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)

        toolBar.jumpToTop?.addTarget(self, action: #selector(jumpToTopFunc), for: .touchUpInside)
        toolBar.jumpToBottom?.addTarget(self, action: #selector(jumpToBottomFunc), for: .touchUpInside)

        updateBtnStatus()
    }

    func updateBtnStatus() {
        if isKeyboardHasPoppedUp {
            toolBar.commandBtn.isEnabled = true
        } else {
            toolBar.commandBtn.isEnabled = false
        }

        if isMenuExpanded {
            toolBar.downBtn.isEnabled = false
        } else {
            toolBar.downBtn.isEnabled = true
        }
    }

    func updateUnRedoButtons() {
        guard let textField = textField else { return }
        toolBar.undoBtn?.isEnabled = textField.bodyView.undoManager!.canUndo || textField.titleView.undoManager!.canUndo
        toolBar.redoBtn?.isEnabled = textField.bodyView.undoManager!.canRedo || textField.titleView.undoManager!.canRedo
    }
    
    func configureShortCutTouchPadHandler() {
        guard let touchPad = toolBar.touchPadBtn else { return }

        var rectFrame = textField.bodyView.fetchRect(textField.bodyView, textField.bodyView.selectedRange)

        cursor = UIView(frame: rectFrame)
        cursor!.backgroundColor = UIColor(red: 0.2941176, green: 0.415686, blue: 0.917647, alpha: 1)
        textField.bodyView.addSubview(cursor!)
        
        guard let cursor = cursor else { return }

        touchPad.handler = { [unowned self] data in
            
            
            cursor.frame.origin = CGPoint(x: rectFrame.origin.x + 1.5*data.velocity.x,
                                           y: rectFrame.origin.y + 1.5*data.velocity.y)

            let upSide = cursor.frame.origin.y
            let downSide = cursor.frame.origin.y + cursor.frame.height
            let leftSide = cursor.frame.origin.x
            let rightSide = cursor.frame.origin.x + cursor.frame.width

            if upSide <= 0 {
                cursor.frame.origin.y = 0
            }

            if leftSide <= 0 {
                cursor.frame.origin.x = 0
            }

            if downSide >= textField.bodyView.frame.height {
                cursor.frame.origin.y = textField.bodyView.frame.height - cursor.frame.height
            }

            if rightSide >= textField.bodyView.frame.width {
                cursor.frame.origin.x = textField.bodyView.frame.width - cursor.frame.width
            }

            let upperSurface = correctCoordinates(cursor.frame.origin.y, position: .bodyView)
            let lowerSurface = upperSurface + cursor.frame.height

            let upperBoundary: CGFloat = 0
            let lowerBoundary = correctCoordinates(toolBar.frame.origin.y, position: .view) - 30

            if upperSurface <= upperBoundary {
                textField.setContentOffset(CGPoint(x: 0,
                                                      y: textField.contentOffset.y - 5), animated: false)
                cursor.frame.origin.y -= 4
                hideTitleBar()
            }

            if lowerSurface >= lowerBoundary {
                textField.setContentOffset(CGPoint(x: 0, y: textField.contentOffset.y + 5), animated: false)
//                cursor!.frame.origin.y += 4
                hideTitleBar()
            }
        }

        touchPad.handleTouchEnded = { [unowned self] in
            let range = self.textField.bodyView.closestPosition(to: cursor.center)!
            let location = self.textField.bodyView.offset(from: textField.bodyView.beginningOfDocument, to: range)
            textField.bodyView.selectedRange = NSRange(location: location, length: 0)

//            let correction = NSRange(location: location-1, length: 0)

            rectFrame = textField.bodyView.fetchRect(textField.bodyView, textField.bodyView.selectedRange)
//            rectFrame.origin.x += textField.bodyFont!.pointSize
            cursor.frame = rectFrame
        }
    }
}
