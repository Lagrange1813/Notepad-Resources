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
    }

    @objc func commandBtnFunc() {
        if articleField.isKeyboardUsing {
            // 此时键盘展开，点击收起键盘并展示command菜单
            toolBar.downBtn.isEnabled = false
            
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false
            articleField.titleView.resignFirstResponder()
            articleField.bodyView.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(307 + 40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                }
//                self.view.layoutIfNeeded()
            })
            
            configureJoyStickHandler()
            
        } else if !articleField.isMenuExpanded, !articleField.isKeyboardUsing {
            // 此时键盘收起，点击展开展示command菜单
            toolBar.downBtn.isEnabled = false
            
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(307 + 40)
                }
                self.view.layoutIfNeeded()
            })
            
            configureJoyStickHandler()
            
        } else if articleField.isMenuExpanded {
            // 此时command菜单展开，点击收起菜单，恢复键盘
            toolBar.downBtn.isEnabled = true
            
            articleField.isMenuExpanded = false
            articleField.isKeyboardUsing = true
            
            UIView.animate(withDuration: 1, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(307)
                }
            })
            
            articleField.bodyView.becomeFirstResponder()
            cursor!.removeFromSuperview()
            cursor = nil
        }
    }
    
    func configureJoyStickHandler() {
        let velocityMultiplier: CGFloat = 0.12
        
//        let position = articleField.bodyView.getRangeRect(articleField.bodyView, articleField.bodyView.selectedRange)
        let position = articleField.bodyView.getRangeRect(articleField.bodyView, articleField.bodyView.selectedRange)
        print(position)
        
        
        
//        cursor = UIView(frame: CGRect(x: position.origin.x - 2,
//                                      y: position.origin.y,
//                                      width: 2,
//                                      height: 30))
        cursor = UIView(frame: position)
        cursor!.backgroundColor = .systemBlue
        articleField.bodyView.addSubview(cursor!)
        
        toolBar.joyStick.handler = { [unowned self] data in
            cursor!.center = CGPoint(x: cursor!.center.x + (data.velocity.x * velocityMultiplier),
                                     y: cursor!.center.y + (data.velocity.y * velocityMultiplier))

            let upSide = cursor!.frame.origin.y
            let downSide = cursor!.frame.origin.y + cursor!.frame.height
            let leftSide = cursor!.frame.origin.x
            let rightSide = cursor!.frame.origin.x + cursor!.frame.width

            if upSide < 0 {
                cursor!.frame.origin.y = 0
            } else if leftSide < 0 {
                cursor!.frame.origin.x = 0
            } else if downSide > view.frame.height {
                cursor!.frame.origin.y = view.frame.height - cursor!.frame.height
            } else if rightSide > view.frame.width {
                cursor!.frame.origin.x = view.frame.width - cursor!.frame.width
            }
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
