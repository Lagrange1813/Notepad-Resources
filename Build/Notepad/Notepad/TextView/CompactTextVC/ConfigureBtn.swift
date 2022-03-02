//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import RxCocoa
import RxSwift
import UIKit

extension CompactTextVC {
    // MARK: - Title bar button configurment

    func configureTitleBarBtnAction() {
        titleBar.listBtn.addTarget(self, action: #selector(listBtnFunc), for: .touchUpInside)
        configureSwitchButton()
        titleBar.typeBtn.addTarget(self, action: #selector(typeBtnFunc), for: .touchUpInside)
    }

    func configureSwitchButton() {
//        titleBar.listBtn.showsMenuAsPrimaryAction = true
        let books = fetchBook()
        var bookList: [String] = []
        var textList: [[String]] = []

        for x in 0 ..< books.count {
            bookList.append(books[x].title!)
            textList.append([])
            let texts = books[x].text!
            for text in texts {
                let postman = text as! Text
                textList[x].append(postman.title!)
            }
        }

        print(bookList)
        print(textList)

        var bookBoard: [UIMenuElement] = []

        for x in 0 ..< bookList.count {
            var textBoard: [UIAction] = []
            for text in textList[x] {
                let item = UIAction(title: text, image: UIImage(systemName: "doc.text")) { _ in
                    UserDefaults.standard.set(<#T##value: Int##Int#>, forKey: <#T##String#>)
                    self.restart()
                }
                textBoard.append(item)
            }
            let item = UIMenu(title: bookList[x], image: UIImage(systemName: "book.closed"), children: textBoard)
            bookBoard.append(item)
        }

        let menu = UIMenu(title: "书籍", children: bookBoard)
        titleBar.listBtn.menu = menu
    }

    @objc func listBtnFunc() {
//        saveData(title: "Test", body: "iahuohihoifbuiauihuuifba", type: "MD")
        restart()
    }

    @objc func typeBtnFunc() {
        let id = UserDefaults.standard.integer(forKey: "CurrentTextID")
        let titleToStore: String = textField.titleView.text
        let bodyToStore: String = textField.bodyView.text
        
        saveText(id: id, title: titleToStore, body: bodyToStore, type: {
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

        addTouchBarBtnObserver()

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

    func addTouchBarBtnObserver() {
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .take(until: rx.deallocated)
            .subscribe(onNext: { _ in
                self.configureShortCutTouchPadHandler()
            })

        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .take(until: rx.deallocated)
            .subscribe(onNext: { _ in
                self.toolBar.removeTouchpadButton()
            })
    }

    func configureShortCutTouchPadHandler() {
        toolBar.addTouchpadButton()

        guard let touchPadBtn = toolBar.touchPadBtn else { return }

        var rectFrame: CGRect?

        touchPadBtn.handleTouchStarted = { [unowned self] in
            rectFrame = textField.bodyView.fetchRect(textField.bodyView, textField.bodyView.selectedRange)

            self.sideCursor = UIView(frame: rectFrame!)
            self.sideCursor!.backgroundColor = UIColor(red: 0.2941176, green: 0.415686, blue: 0.917647, alpha: 1)
            textField.bodyView.addSubview(self.sideCursor!)
        }

        touchPadBtn.handler = { [unowned self] data in
            sideCursor!.frame.origin = CGPoint(x: rectFrame!.origin.x + 1.5*data.velocity.x,
                                               y: rectFrame!.origin.y + 1.5*data.velocity.y)

            let upSide = sideCursor!.frame.origin.y
            let downSide = sideCursor!.frame.origin.y + sideCursor!.frame.height
            let leftSide = sideCursor!.frame.origin.x
            let rightSide = sideCursor!.frame.origin.x + sideCursor!.frame.width

            if upSide <= 0 {
                sideCursor!.frame.origin.y = 0
            }

            if leftSide <= 0 {
                sideCursor!.frame.origin.x = 0
            }

            if downSide >= textField.bodyView.frame.height {
                sideCursor!.frame.origin.y = textField.bodyView.frame.height - sideCursor!.frame.height
            }

            if rightSide >= textField.bodyView.frame.width {
                sideCursor!.frame.origin.x = textField.bodyView.frame.width - sideCursor!.frame.width
            }

            let upperSurface = correctCoordinates(sideCursor!.frame.origin.y, position: .bodyView)
            let lowerSurface = upperSurface + sideCursor!.frame.height

            let upperBoundary: CGFloat = 0
            let lowerBoundary = correctCoordinates(toolBar.frame.origin.y, position: .view) - 30

            if upperSurface <= upperBoundary {
                textField.setContentOffset(CGPoint(x: 0,
                                                   y: textField.contentOffset.y - 5), animated: false)
                sideCursor!.frame.origin.y -= 4
                hideTitleBar()
            }

            if lowerSurface >= lowerBoundary {
                textField.setContentOffset(CGPoint(x: 0, y: textField.contentOffset.y + 5), animated: false)
                hideTitleBar()
            }
        }

        touchPadBtn.handleTouchEnded = { [unowned self] in
            let range = self.textField.bodyView.closestPosition(to: sideCursor!.center)!
            let location = self.textField.bodyView.offset(from: textField.bodyView.beginningOfDocument, to: range)
            textField.bodyView.selectedRange = NSRange(location: location, length: 0)

            sideCursor!.removeFromSuperview()
            self.sideCursor = nil
        }
    }
}
