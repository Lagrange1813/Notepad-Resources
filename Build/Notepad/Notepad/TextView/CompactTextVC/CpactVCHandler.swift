//
//  Handler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension CompactTextVC {
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        guard let textField = textField else { return }
        if textView == textField.bodyView {
            updateUnRedoButtons()

        } else if textView == textField.titleView {
            updateUnRedoButtons()
        }

        var selectedView: CustomTextView?
        
        if bodyViewUnderEditing {
            selectedView = textField.bodyView
        } else if titleViewUnderEditing {
            selectedView = textField.titleView
        }
        if let selectedView = selectedView {
            let cursorRange = selectedView.selectedRange
            
            let allString = selectedView.attributedText.string
            let startIndex = allString.index(allString.startIndex, offsetBy: cursorRange.location - 1)
            let range: Range = startIndex ..< allString.endIndex
            let stringToFind = allString[range]
            let index = stringToFind.firstIndex(of: "）")
            let offset: Int = index?.utf16Offset(in: stringToFind) ?? 1000
            print(offset)
        }
    }
}
