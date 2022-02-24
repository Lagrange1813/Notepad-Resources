//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CompactTextVC {
    // MARK: - Title bar button configurment

    func configureTitleBarBtnAction() {
        titleBar.listBtn.addTarget(self, action: #selector(listBtnFunc), for: .touchUpInside)
        titleBar.typeBtn.addTarget(self, action: #selector(typeBtnFunc), for: .touchUpInside)
    }

    @objc func listBtnFunc() {
        saveData(title: "Test", body: "iahuohihoifbuiauihuuifba", type: "MD")
        restart()
    }
    
    @objc func typeBtnFunc() {
        let titleToStore: String = textField.titleView.text
        let bodyToStore: String = textField.bodyView.text

        saveData(title: titleToStore, body: bodyToStore, type: {
            switch type {
            case "Text": return "MD"
            case "MD": return "Text"
            default: return ""
            }
        }())
        restart()
    }

    // MARK: - Tool bar button configurment

    func configureToolBarBtnAction() {
        toolBar.commandBtn.addTarget(self, action: #selector(commandBtnFunc), for: .touchUpInside)

        toolBar.undoBtn.addTarget(self, action: #selector(undoFunc), for: .touchUpInside)
        
        toolBar.pasteBtn.addTarget(self, action: #selector(pasteBtnFunc), for: .touchUpInside)
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)

        toolBar.redoBtn?.addTarget(self, action: #selector(redoFunc), for: .touchUpInside)
        
        toolBar.quotesBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.sqrBracketsBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.bracketsBtn?.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)

        toolBar.jumpToTop?.addTarget(self, action: #selector(jumpToTopFunc), for: .touchUpInside)
        toolBar.jumpToBottom?.addTarget(self, action: #selector(jumpToBottomFunc), for: .touchUpInside)

        updateBtnStatus()
    }

    func updateBtnStatus() {
        if isKeyboardHasPoppedUp {
            toolBar.commandBtn.isEnabled = true
        } else {
            toolBar.commandBtn.isEnabled = false
        }

        if isMenuExpanded {
            toolBar.downBtn.isEnabled = false
        } else {
            toolBar.downBtn.isEnabled = true
        }
    }

    func updateUnRedoButtons() {
        guard let textField = textField else { return }
        toolBar.undoBtn?.isEnabled = textField.bodyView.undoManager!.canUndo || textField.titleView.undoManager!.canUndo
        toolBar.redoBtn?.isEnabled = textField.bodyView.undoManager!.canRedo || textField.titleView.undoManager!.canRedo
    }
}
