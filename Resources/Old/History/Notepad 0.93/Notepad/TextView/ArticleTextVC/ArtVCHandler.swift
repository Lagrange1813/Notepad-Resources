//
//  Handler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension ArticleTextVC {
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if textView == articleField.bodyView {
            updateUnRedoButtons()

        } else if textView == articleField.titleView {
            updateUnRedoButtons()
        }
    }
}
