//
//  TextViewDC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import CoreData
import UIKit

extension CommonTextVC {
    func textViewDidChange(_ textView: UITextView) {
        guard let articleField = articleField else { return }
        if textView == articleField.bodyView {
            articleField.bodyView.sizeToFit()
            refreshAndSaveText()

        } else if textView == articleField.titleView {
            articleField.titleView.sizeToFit()
            refreshAndSaveText()
        }
        articleField.resize()
    }

    func refreshAndSaveText() {
        let temp = articleField.titleView.text! + articleField.bodyView.text!

        if showCounter {
            counter.refreshLabel(temp.count)
            refreshCounter()
        }

        if saveText {
            let titleToStore: String = articleField.titleView.text
            let bodyToStore: String = articleField.bodyView.text

            saveData(title: titleToStore, body: bodyToStore, type: "text")
        }
    }
}
