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

}
