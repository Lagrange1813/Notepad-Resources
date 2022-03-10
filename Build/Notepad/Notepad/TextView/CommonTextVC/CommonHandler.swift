//
//  CommonHandler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import CoreData
import UIKit

extension CommonTextVC {
    func textViewDidChange(_ textView: UITextView) {
        guard let textField = textField else { return }
        if textView == textField.bodyView {
            textField.bodyView.sizeToFit()
            refreshAndSaveText()

        } else if textView == textField.titleView {
            textField.titleView.sizeToFit()
            refreshAndSaveText()
        }
        textField.resize()
    }

    func refreshAndSaveText() {
        let temp = textField.titleView.text! + textField.bodyView.text!

        if showCounter {
            counter.refreshLabel(temp.count)
            refreshCounter()
        }

        if toSaveText {
            let titleToStore: String = textField.titleView.text
            let bodyToStore: String = textField.bodyView.text

            let id = UUID(uuidString: UserDefaults.standard.value(forKey: "CurrentTextID") as! String)
            saveText(id: id!, title: titleToStore, body: bodyToStore, type: type)
        }
    }
}
