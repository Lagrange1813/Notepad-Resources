//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CurrentTextVC {
    func configureBtnAction() {
        toolBar.commandBtn.addTarget(self, action: #selector(commandBtnFunc), for: .touchUpInside)
        
        toolBar.undoBtn.addTarget(self, action: #selector(undoFunc), for: .touchUpInside)
        toolBar.redoBtn.addTarget(self, action: #selector(redoFunc), for: .touchUpInside)
        
        toolBar.pasteBtn.addTarget(self, action: #selector(pasteBtnFunc), for: .touchUpInside)
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)
        
        toolBar.quotesBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.sqrBracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.bracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        
        toolBar.jumpToTop.addTarget(self, action: #selector(jumpToTopFunc), for: .touchUpInside)
        toolBar.jumpToBottom.addTarget(self, action: #selector(jumpToBottomFunc), for: .touchUpInside)
        
        updateBtnStatus()
    }
    
    func updateBtnStatus() {
        if isKeyboardHasPoppedUp {
            toolBar.commandBtn.isEnabled = true
        } else {
            toolBar.commandBtn.isEnabled = false
        }
        
        if articleField.isMenuExpanded {
            toolBar.downBtn.isEnabled = false
        } else {
            toolBar.downBtn.isEnabled = true
        }
    }

    @objc func commandBtnFunc() {
        if articleField.isKeyboardUsing {
            // 此时键盘展开，点击收起键盘并展示command菜单
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false
            
            updateBtnStatus()
            
            articleField.titleView.resignFirstResponder()
            articleField.bodyView.resignFirstResponder()
            
            toolBar.configureTouchPad(moveDistance!)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(self.moveDistance! + 40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                }
//                self.view.layoutIfNeeded()
            })
            
            configureTouchPadHandler()
            
        } else if !articleField.isMenuExpanded, !articleField.isKeyboardUsing {
            // 此时键盘收起，点击展开展示command菜单
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false
            
            updateBtnStatus()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(self.moveDistance! + 40)
                }
                self.view.layoutIfNeeded()
            })
            
            configureTouchPadHandler()
            
        } else if articleField.isMenuExpanded {
            // 此时command菜单展开，点击收起菜单，恢复键盘
            articleField.isMenuExpanded = false
            articleField.isKeyboardUsing = true
            
            updateBtnStatus()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(self.moveDistance!)
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.toolBar.touchPad.isHidden = true
            })
            
            articleField.bodyView.becomeFirstResponder()
            if let cursor = cursor {
                cursor.removeFromSuperview()
                self.cursor = nil
            }
        }
    }
    
    func configureTouchPadHandler() {
        guard let touchPad = toolBar.touchPad else { return }
        
        touchPad.isHidden = false
        
        var rectFrame = articleField.bodyView.getRect(articleField.bodyView, articleField.bodyView.selectedRange)

        cursor = UIView(frame: rectFrame)
        cursor!.backgroundColor = ColorCollection.cursorColor
        articleField.bodyView.addSubview(cursor!)
        
        let line: [CGFloat] = [50, 150]
        let multiplier: [CGFloat] = [0.5, 1, 2]
        
        touchPad.handler = { [unowned self] data in
            cursor!.frame.origin = {
                let x = rectFrame.origin.x
                let y = rectFrame.origin.y
                
                let touchPadX = data.velocity.x
                let touchPadY = data.velocity.y
                
                var currentX: CGFloat!
                var currentY: CGFloat!
                
                let signInX = touchPadX/abs(touchPadX)
                let signInY = touchPadY/abs(touchPadY)
                
                switch abs(touchPadX) {
                case 0...line[0]:
                    currentX = x + multiplier[0]*touchPadX
                case line[0]...line[1]:
                    currentX = x + multiplier[0]*line[0]*signInX + multiplier[1]*(touchPadX - line[0]*signInX)
                case line[1]...1000:
                    currentX = x + multiplier[0]*line[0]*signInX + multiplier[1]*(line[1] - line[0])*signInX + multiplier[2]*(touchPadX - line[1]*signInX)
                default:
                    currentX = x
                }
                
                switch abs(touchPadY) {
                case 0...line[0]:
                    currentY = y + multiplier[0]*touchPadY
                case line[0]...line[1]:
                    currentY = y + multiplier[0]*line[0]*signInY + multiplier[1]*(touchPadY - line[0]*signInY)
                case line[1]...1000:
                    currentY = y + multiplier[0]*line[0]*signInY + multiplier[1]*(line[1] - line[0])*signInY + multiplier[2]*(touchPadY - line[1]*signInY)
                default:
                    currentY = y
                }
                
                return CGPoint(x: currentX, y: currentY)
            }()

            let upSide = cursor!.frame.origin.y
            let downSide = cursor!.frame.origin.y + cursor!.frame.height
            let leftSide = cursor!.frame.origin.x
            let rightSide = cursor!.frame.origin.x + cursor!.frame.width

            if upSide <= 0 {
                cursor!.frame.origin.y = 0
            }
            
            if leftSide <= 0 {
                cursor!.frame.origin.x = 0
            }
            
            if downSide >= articleField.bodyView.frame.height {
                cursor!.frame.origin.y = articleField.bodyView.frame.height - cursor!.frame.height
            }
            
            if rightSide >= articleField.bodyView.frame.width {
                cursor!.frame.origin.x = articleField.bodyView.frame.width - cursor!.frame.width
            }
            
//            let absPoint = cursor!.convert(cursor!.frame.origin, to: articleField)
//            print(absPoint)
        }
        
        touchPad.handleTouchEnded = { [unowned self] in
            print("ended")
            let range = self.articleField.bodyView.closestPosition(to: self.cursor!.center)!
            let location = self.articleField.bodyView.offset(from: articleField.bodyView.beginningOfDocument, to: range)
            articleField.bodyView.selectedRange = NSRange(location: location, length: 0)
            
//            let correction = NSRange(location: location-1, length: 0)
            
            rectFrame = articleField.bodyView.getRect(articleField.bodyView, articleField.bodyView.selectedRange)
//            rectFrame.origin.x += articleField.bodyFont!.pointSize
            cursor!.frame = rectFrame
        }
    }
    
    func updateUnRedoButtons() {
        toolBar.undoBtn.isEnabled = articleField.bodyView.undoManager!.canUndo || articleField.titleView.undoManager!.canUndo
        toolBar.redoBtn.isEnabled = articleField.bodyView.undoManager!.canRedo || articleField.titleView.undoManager!.canRedo
    }
    
    @objc func undoFunc(_ sender: Any) {
        if articleField.trackingView == "body" {
            articleField.bodyView.undoManager?.undo()
        } else if articleField.trackingView == "title" {
            articleField.titleView.undoManager?.undo()
        }
        updateUnRedoButtons()
    }

    @objc func redoFunc(_ sender: Any) {
        if articleField.trackingView == "body" {
            articleField.bodyView.undoManager?.redo()
        } else if articleField.trackingView == "title" {
            articleField.titleView.undoManager?.redo()
        }
        updateUnRedoButtons()
    }
    
    @objc func pasteBtnFunc() {
        let pasteBoard = UIPasteboard.general
        let dataToPaste = pasteBoard.string
        toolBar.pasteBtn.argument = dataToPaste
        toolBar.pasteBtn.addTarget(self, action: #selector(insertFromCursor), for: .touchUpInside)
    }

    @objc func downBtnFunc() {
        articleField.titleView.resignFirstResponder()
        articleField.bodyView.resignFirstResponder()
        articleField.isShortcutBtnInputing = false
        articleField.titleViewUnderEditing = false
        articleField.bodyViewUnderEditing = false
    }

    @objc func shortcutFunc(sender: CustomBtn, forEvent: UIEvent) {
        insertFromCursor(sender: sender, forEvent: forEvent)
        
        var selectedView: CustomTextView?
        
        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }
        if let selectedView = selectedView {
            let location = selectedView.selectedRange.location
            selectedView.selectedRange = NSRange(location: location - 1, length: 0)
            articleField.isShortcutBtnInputing = true
        }
    }
    
    @objc func jumpToTopFunc() {
        let selectedView = articleField.bodyView!
        
        selectedView.selectedRange = NSRange(location: 0, length: 0)
            
        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()
            
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.isNavigationBarHidden = false
        })
    }
    
    @objc func jumpToBottomFunc() {
        let selectedView = articleField.bodyView!
        
        selectedView.selectedRange = NSRange(location: selectedView.text!.count,
                                             length: 0)
        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()
            
        UIView.animate(withDuration: 0.3, animations: {
//                self.navigationController?.isNavigationBarHidden = true  WOC, NB!
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        })
    }
    
    @objc func insertFromCursor(sender: CustomBtn, forEvent event: UIEvent) {
        var selectedView: CustomTextView?
        
        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }
        
        if let selectedView = selectedView {
            let range = selectedView.selectedRange
            let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
            let end = selectedView.position(from: start, offset: range.length)!
            let textRange = selectedView.textRange(from: start, to: end)!
            selectedView.replace(textRange, withText: sender.argument!)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == articleField.bodyView {
            if text == "\n", articleField.isShortcutBtnInputing, articleField.bodyViewUnderEditing {
                let location = articleField.bodyView.selectedRange.location
                articleField.bodyView.selectedRange = NSRange(location: location + 1, length: 0)
                articleField.isShortcutBtnInputing = false
                
                return false
            }
            return true
            
        } else if textView == articleField.titleView {
            if text == "\n" {
                if articleField.isShortcutBtnInputing, articleField.titleViewUnderEditing {
                    let location = articleField.titleView.selectedRange.location
                    articleField.titleView.selectedRange = NSRange(location: location + 1, length: 0)
                    articleField.isShortcutBtnInputing = false
                } else {
                    articleField.bodyView.becomeFirstResponder()
                }
                return false
            }
            return true
        }
        
        return true
    }
}
