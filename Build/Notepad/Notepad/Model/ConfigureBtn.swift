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
        articleField.resignFirstResponder()
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
        let range = articleField.selectedRange
        let start = articleField.position(from: articleField.beginningOfDocument, offset: range.location)!
        let end = articleField.position(from: start, offset: range.length)!
        let textRange = articleField.textRange(from: start, to: end)!
        articleField.replace(textRange, withText: sender.argument!)
    }
}
