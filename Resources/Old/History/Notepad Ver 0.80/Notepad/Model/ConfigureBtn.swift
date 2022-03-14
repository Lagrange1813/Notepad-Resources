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
        print("down")
        articleField.titleView.resignFirstResponder()
        articleField.bodyView.resignFirstResponder()
    }

    func test() {
        let btn = CustomBtn()
        btn.setTitle("Test", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.systemGray, for: .highlighted)
        btn.argument = "\\\""

        view.addSubview(btn)

        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.width.height.equalTo(50)
        }

        btn.addTarget(self, action: #selector(insertFromCursor), for: .touchUpInside)
    }

    @objc func insertFromCursor(sender: CustomBtn, forEvent event: UIEvent) {
        let range = articleField.bodyView.selectedRange
        let start = articleField.bodyView.position(from: articleField.bodyView.beginningOfDocument, offset: range.location)!
        let end = articleField.bodyView.position(from: start, offset: range.length)!
        let textRange = articleField.bodyView.textRange(from: start, to: end)!
        articleField.bodyView.replace(textRange, withText: sender.argument!)
    }
}
