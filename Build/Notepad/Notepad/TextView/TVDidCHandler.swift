//
//  Handler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension CurrentTextVC {
    func textViewDidChange(_ textView: UITextView) {
        if textView == articleField.bodyView {
            articleField.bodyView.sizeToFit()
            updateUnRedoButtons()
            refreshAndSaveText()
        } else if textView == articleField.titleView {
            articleField.titleView.sizeToFit()
            updateUnRedoButtons()
            refreshAndSaveText()
        }
        articleField.resize()
        refreshCounter()
    }

    func refreshAndSaveText() {
        let temp = articleField.titleView.text! + articleField.bodyView.text!

        counter.refreshLabel(temp.count)
        refreshCounter()

        let titleToStore: String = articleField.titleView.text
        let bodyToStore: String = articleField.bodyView.text

        saveData(title: titleToStore, body: bodyToStore)
    }
}


