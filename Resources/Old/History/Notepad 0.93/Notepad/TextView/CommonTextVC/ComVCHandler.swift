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
        if textView == articleField.bodyView {
            articleField.bodyView.sizeToFit()
            refreshAndSaveText()

        } else if textView == articleField.titleView {
            articleField.titleView.sizeToFit()
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
