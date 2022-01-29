//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CurrentTextVC {
    func configureBtnAction() {
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

    func updateUnRedoButtons() {
        toolBar.undoBtn.isEnabled = articleField.bodyView.undoManager!.canUndo || articleField.titleView.undoManager!.canUndo
        toolBar.redoBtn.isEnabled = articleField.bodyView.undoManager?.canRedo ?? false
    }
    
    @objc func undoFunc(_ sender: Any) {
        articleField.bodyView.undoManager?.undo()
        updateUnRedoButtons()
    }

    @objc func redoFunc(_ sender: Any) {
        articleField.bodyView.undoManager?.redo()
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
        if text == "\n", articleField.isShortcutBtnInputing, articleField.bodyViewUnderEditing {
            let location = articleField.bodyView.selectedRange.location
            articleField.bodyView.selectedRange = NSRange(location: location + 1, length: 0)
            articleField.isShortcutBtnInputing = false
            
            return false
        }
        return true
    }
}
