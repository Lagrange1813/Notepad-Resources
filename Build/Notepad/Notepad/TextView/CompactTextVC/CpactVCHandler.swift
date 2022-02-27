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
    }
}
