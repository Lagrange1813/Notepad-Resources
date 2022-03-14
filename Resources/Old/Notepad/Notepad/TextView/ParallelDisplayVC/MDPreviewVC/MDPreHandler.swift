//
//  MDPreHandler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/28.
//

import UIKit

extension MDPreviewVC {
    func textViewDidChange(_ textView: UITextView) {
        guard let textField = textField else { return }
        if textView == textField.bodyView {
            textField.bodyView.sizeToFit()
            refreshWordCounter()

        } else if textView == textField.titleView {
            textField.titleView.sizeToFit()
            refreshWordCounter()
        }
        textField.resize()
    }

    func refreshWordCounter() {
        let temp = textField.titleView.text! + textField.body!

        if showCounter {
            counter.refreshLabel(temp.count)
            refreshCounter()
        }
    }
}
