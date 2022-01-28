//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CurrentTextVC {

    func configureBtnAction() {
        toolBar.pasteBtn.addTarget(self, action: #selector(pasteBtnFunc), for: .touchUpInside)
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)
        
        toolBar.quotesBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.sqrBracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.bracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        
        toolBar.jumpToTop.addTarget(self, action: #selector(jumpToTopFunc), for: .touchUpInside)
        toolBar.jumpToBottom.addTarget(self, action: #selector(jumpToBottomFunc), for: .touchUpInside)
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
            selectedView.selectedRange = NSRange(location: location-1,length: 0)
            articleField.isShortcutBtnInputing = true
        }
        
    }
    
    @objc func jumpToTopFunc() {
        var selectedView: CustomTextView?
        
        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }
        
        if let selectedView = selectedView {
            selectedView.selectedRange = NSRange(location: 0, length: 0)
            
            let range = selectedView.selectedRange
            let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
            let end = selectedView.position(from: start, offset: range.length)!
            let textRange = selectedView.textRange(from: start, to: end)!
            selectedView.replace(textRange, withText: "")
            
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.isNavigationBarHidden = false
            })
        }
    }
    
    @objc func jumpToBottomFunc() {
        var selectedView: CustomTextView?
        
        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }
        
        if let selectedView = selectedView {
            selectedView.selectedRange = NSRange(location: selectedView.text!.count,
                                                 length: 0)
            let range = selectedView.selectedRange
            let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
            let end = selectedView.position(from: start, offset: range.length)!
            let textRange = selectedView.textRange(from: start, to: end)!
            selectedView.replace(textRange, withText: "")
            
            UIView.animate(withDuration: 0.3, animations: {
//                self.navigationController?.isNavigationBarHidden = true  WOC, NB!
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            })
        }
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
        if text == "\n" && articleField.isShortcutBtnInputing{
            var selectedView: CustomTextView?
            
            if articleField.bodyViewUnderEditing {
                selectedView = articleField.bodyView
            } else if articleField.titleViewUnderEditing {
                selectedView = articleField.titleView
            }
            if let selectedView = selectedView {
                let location = selectedView.selectedRange.location
                selectedView.selectedRange = NSRange(location: location+1,length: 0)
                articleField.isShortcutBtnInputing = false
            }
            return false
        }
        return true
    }

}
