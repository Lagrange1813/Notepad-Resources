//
//  ToolBarBtnFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

extension CompactTextVC {
    // MARK: - Tool bar fixed button function configurment

    

    // MARK: - Toolbar scrollview button function configurment

  @objc func shortcutFunc(sender: CustomBtn) {
    insertFromCursor(sender: sender)
    
    retreat = sender.retreat!
    
    var selectedView: CustomTextView?
    
    if bodyViewUnderEditing {
      selectedView = textField.bodyView
    } else if titleViewUnderEditing {
      selectedView = textField.titleView
    }
    if let selectedView = selectedView {
      let location = selectedView.selectedRange.location
      selectedView.selectedRange = NSRange(location: location - retreat, length: 0)
      isShortcutBtnInputing = true
      
      if sender.argument!.count > 1 {
        let cursorRange = selectedView.selectedRange
        let string = "请输入文字"
        let tipString = NSMutableAttributedString(string: string)
        selectedView.setAttributedMarkedText(tipString, selectedRange: cursorRange)
      }
      
//      let allString = selectedView.attributedText.string
//      let startIndex = allString.index(allString.startIndex, offsetBy: cursorRange.location - 1)
//      let range: Range = startIndex..<allString.endIndex
//      let stringToFind = allString[range]
//      let index = stringToFind.firstIndex(of: "）")
//      let offset: Int = index!.utf16Offset(in: stringToFind)
//      print(offset)
    }
  }
  
  @objc func insertFromCursor(sender: CustomBtn) {
      var selectedView: CustomTextView?

      if bodyViewUnderEditing {
          selectedView = textField.bodyView
      } else if titleViewUnderEditing {
          selectedView = textField.titleView
      }

      if let selectedView = selectedView {
          let range = selectedView.selectedRange
          let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
          let end = selectedView.position(from: start, offset: range.length)!
          let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: sender.argument!)
      }
  }

    @objc func jumpToTopFunc() {
        let selectedView = textField.bodyView!

        selectedView.selectedRange = NSRange(location: 0, length: 0)

        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()

        textField.setContentOffset(CGPoint(x: 0, y: -TitleBar.height() - titleBarOffset), animated: true)

        if !fullScreen {
            showTitleBar()
        }
    }

    @objc func jumpToBottomFunc() {
        let selectedView = textField.bodyView!

        selectedView.selectedRange = NSRange(location: selectedView.text!.count,
                                             length: 0)
        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()

        hideTitleBar()
    }

    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == textField.bodyView {
            if text == "\n", isShortcutBtnInputing, bodyViewUnderEditing {
                let location = textField.bodyView.selectedRange.location
                textField.bodyView.selectedRange = NSRange(location: location + retreat, length: 0)
                isShortcutBtnInputing = false

                return false
            }
            return true

        } else if textView == textField.titleView {
            if text == "\n" {
                if isShortcutBtnInputing, titleViewUnderEditing {
                    let location = textField.titleView.selectedRange.location
                    textField.titleView.selectedRange = NSRange(location: location + retreat, length: 0)
                    isShortcutBtnInputing = false
                } else {
                    textField.bodyView.becomeFirstResponder()
                }
                return false
            }
            return true
        }
        return true
    }
}

