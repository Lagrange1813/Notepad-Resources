//
//  ConfigureBtn.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/27.
//

import UIKit

extension CurrentTextVC {
    // MARK: - Title bar button configurment

    func configureTitleBarBtnAction() {
        titleBar.listBtn.addTarget(self, action: #selector(listBtnFunc), for: .touchUpInside)
    }
    
    @objc func listBtnFunc() {
        print("yes")
//        splitViewController?.show(.supplementary)
    }

    // MARK: - Tool bar button configurment

    func configureToolBarBtnAction() {
        toolBar.commandBtn.addTarget(self, action: #selector(commandBtnFunc), for: .touchUpInside)

        toolBar.undoBtn.addTarget(self, action: #selector(undoFunc), for: .touchUpInside)
        toolBar.redoBtn.addTarget(self, action: #selector(redoFunc), for: .touchUpInside)

        toolBar.pasteBtn.addTarget(self, action: #selector(pasteBtnFunc), for: .touchUpInside)
        toolBar.downBtn.addTarget(self, action: #selector(downBtnFunc), for: .touchUpInside)

        toolBar.quotesBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.sqrBracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)
        toolBar.bracketsBtn.addTarget(self, action: #selector(shortcutFunc), for: .touchUpInside)

        toolBar.jumpToTop.addTarget(self, action: #selector(jumpToTopFunc), for: .touchUpInside)
        toolBar.jumpToBottom.addTarget(self, action: #selector(jumpToBottomFunc), for: .touchUpInside)

        updateBtnStatus()
    }

    func updateBtnStatus() {
        if isKeyboardHasPoppedUp {
            toolBar.commandBtn.isEnabled = true
        } else {
            toolBar.commandBtn.isEnabled = false
        }

        if articleField.isMenuExpanded {
            toolBar.downBtn.isEnabled = false
        } else {
            toolBar.downBtn.isEnabled = true
        }
    }

    @objc func commandBtnFunc() {
        if articleField.isKeyboardUsing {
            // 此时键盘展开，点击收起键盘并展示command菜单
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false

            updateBtnStatus()

            articleField.titleView.resignFirstResponder()
            articleField.bodyView.resignFirstResponder()

            toolBar.configureTouchPad(moveDistance!)

            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    if isFullScreen() {
                        make.height.equalTo(self.moveDistance! + 40)
                    } else {
                        make.height.equalTo(self.moveDistance! + 40 - 5)
                    }

                    if isFullScreen() {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    } else {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(5)
                    }
                }
//                self.view.layoutIfNeeded()
            })

            configureTouchPadHandler()

        } else if !articleField.isMenuExpanded, !articleField.isKeyboardUsing {
            // 此时键盘收起，点击展开展示command菜单
            articleField.isMenuExpanded = true
            articleField.isKeyboardUsing = false

            updateBtnStatus()

            UIView.animate(withDuration: 0.5, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(self.moveDistance! + 40)
                }
                self.view.layoutIfNeeded()
            })

            configureTouchPadHandler()

        } else if articleField.isMenuExpanded {
            // 此时command菜单展开，点击收起菜单，恢复键盘
            articleField.isMenuExpanded = false
            articleField.isKeyboardUsing = true

            updateBtnStatus()

            UIView.animate(withDuration: 0.25, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(self.moveDistance!)
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.toolBar.touchPad.isHidden = true
            })

            articleField.bodyView.becomeFirstResponder()
            if let cursor = cursor {
                cursor.removeFromSuperview()
                self.cursor = nil
            }
        }
    }

    func configureTouchPadHandler() {
        guard let touchPad = toolBar.touchPad else { return }

        touchPad.isHidden = false

        var rectFrame = articleField.bodyView.fetchRect(articleField.bodyView, articleField.bodyView.selectedRange)

        cursor = UIView(frame: rectFrame)
        cursor!.backgroundColor = fetchColor(place: .cursor, mode: .light)
        articleField.bodyView.addSubview(cursor!)

        touchPad.handler = { [unowned self] data in
            cursor!.frame.origin = CGPoint(x: rectFrame.origin.x + 1.5*data.velocity.x,
                                           y: rectFrame.origin.y + 1.5*data.velocity.y)

            let upSide = cursor!.frame.origin.y
            let downSide = cursor!.frame.origin.y + cursor!.frame.height
            let leftSide = cursor!.frame.origin.x
            let rightSide = cursor!.frame.origin.x + cursor!.frame.width

            if upSide <= 0 {
                cursor!.frame.origin.y = 0
            }

            if leftSide <= 0 {
                cursor!.frame.origin.x = 0
            }

            if downSide >= articleField.bodyView.frame.height {
                cursor!.frame.origin.y = articleField.bodyView.frame.height - cursor!.frame.height
            }

            if rightSide >= articleField.bodyView.frame.width {
                cursor!.frame.origin.x = articleField.bodyView.frame.width - cursor!.frame.width
            }

            let upperSurface = correctCoordinates(cursor!.frame.origin.y, position: .bodyView)
            let lowerSurface = upperSurface + cursor!.frame.height

            let upperBoundary: CGFloat = 0
            let lowerBoundary = correctCoordinates(toolBar.frame.origin.y, position: .view) - 30

            if upperSurface <= upperBoundary {
                articleField.setContentOffset(CGPoint(x: 0,
                                                      y: articleField.contentOffset.y - 5), animated: false)
                cursor!.frame.origin.y -= 4
                hideTitleBar()
                print("up")
            }

            if lowerSurface >= lowerBoundary {
                articleField.setContentOffset(CGPoint(x: 0, y: articleField.contentOffset.y + 5), animated: false)
//                cursor!.frame.origin.y += 4
                hideTitleBar()
                print("down")
            }

//            let cursorPosition = cursor!.frame.origin.y
//            print(cursorPosition)
//            print(correctCoordinates(cursorPosition, position: .bodyView))
//            let toolBarPosition = toolBar.frame.origin.y
//            print(toolBarPosition)
//            print(correctCoordinates(toolBarPosition, position: .view))
//            print("")
        }

        touchPad.handleTouchEnded = { [unowned self] in
            print("ended")
            let range = self.articleField.bodyView.closestPosition(to: self.cursor!.center)!
            let location = self.articleField.bodyView.offset(from: articleField.bodyView.beginningOfDocument, to: range)
            articleField.bodyView.selectedRange = NSRange(location: location, length: 0)

//            let correction = NSRange(location: location-1, length: 0)

            rectFrame = articleField.bodyView.fetchRect(articleField.bodyView, articleField.bodyView.selectedRange)
//            rectFrame.origin.x += articleField.bodyFont!.pointSize
            cursor!.frame = rectFrame
        }
    }

    func updateUnRedoButtons() {
        toolBar.undoBtn.isEnabled = articleField.bodyView.undoManager!.canUndo || articleField.titleView.undoManager!.canUndo
        toolBar.redoBtn.isEnabled = articleField.bodyView.undoManager!.canRedo || articleField.titleView.undoManager!.canRedo
    }

    @objc func undoFunc(_ sender: Any) {
        if articleField.trackingView == "body" {
            articleField.bodyView.undoManager?.undo()
        } else if articleField.trackingView == "title" {
            articleField.titleView.undoManager?.undo()
        }
        updateUnRedoButtons()
    }

    @objc func redoFunc(_ sender: Any) {
        if articleField.trackingView == "body" {
            articleField.bodyView.undoManager?.redo()
        } else if articleField.trackingView == "title" {
            articleField.titleView.undoManager?.redo()
        }
        updateUnRedoButtons()
    }

    @objc func pasteBtnFunc() {
        let pasteBoard = UIPasteboard.general
        guard let dataToPaste = pasteBoard.string else { return }
        toolBar.pasteBtn.argument = dataToPaste
        toolBar.pasteBtn.addTarget(self, action: #selector(insertFromCursor), for: .touchUpInside)
    }

    @objc func downBtnFunc() {
        articleField.titleView.resignFirstResponder()
        articleField.bodyView.resignFirstResponder()
        articleField.isShortcutBtnInputing = false
        articleField.titleViewUnderEditing = false
        articleField.bodyViewUnderEditing = false
    }

    @objc func shortcutFunc(sender: CustomBtn, forEvent: UIEvent) {
        insertFromCursor(sender: sender, forEvent: forEvent)

        var selectedView: CustomTextView?

        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }
        if let selectedView = selectedView {
            let location = selectedView.selectedRange.location
            selectedView.selectedRange = NSRange(location: location - 1, length: 0)
            articleField.isShortcutBtnInputing = true
        }
    }

    @objc func jumpToTopFunc() {
        let selectedView = articleField.bodyView!

        selectedView.selectedRange = NSRange(location: 0, length: 0)

        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()

        articleField.setContentOffset(CGPoint(x: 0, y: -TitleBar.height() - titleBarOffset), animated: true)

        showTitleBar()
    }

    @objc func jumpToBottomFunc() {
        let selectedView = articleField.bodyView!

        selectedView.selectedRange = NSRange(location: selectedView.text!.count,
                                             length: 0)
        let range = selectedView.selectedRange
        let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
        let end = selectedView.position(from: start, offset: range.length)!
        let textRange = selectedView.textRange(from: start, to: end)!
        selectedView.replace(textRange, withText: "")
        selectedView.becomeFirstResponder()

        hideTitleBar()
    }

    @objc func insertFromCursor(sender: CustomBtn, forEvent event: UIEvent) {
        var selectedView: CustomTextView?

        if articleField.bodyViewUnderEditing {
            selectedView = articleField.bodyView
        } else if articleField.titleViewUnderEditing {
            selectedView = articleField.titleView
        }

        if let selectedView = selectedView {
            let range = selectedView.selectedRange
            let start = selectedView.position(from: selectedView.beginningOfDocument, offset: range.location)!
            let end = selectedView.position(from: start, offset: range.length)!
            let textRange = selectedView.textRange(from: start, to: end)!
            selectedView.replace(textRange, withText: sender.argument!)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == articleField.bodyView {
            if text == "\n", articleField.isShortcutBtnInputing, articleField.bodyViewUnderEditing {
                let location = articleField.bodyView.selectedRange.location
                articleField.bodyView.selectedRange = NSRange(location: location + 1, length: 0)
                articleField.isShortcutBtnInputing = false

                return false
            }
            return true

        } else if textView == articleField.titleView {
            if text == "\n" {
                if articleField.isShortcutBtnInputing, articleField.titleViewUnderEditing {
                    let location = articleField.titleView.selectedRange.location
                    articleField.titleView.selectedRange = NSRange(location: location + 1, length: 0)
                    articleField.isShortcutBtnInputing = false
                } else {
                    articleField.bodyView.becomeFirstResponder()
                }
                return false
            }
            return true
        }

        return true
    }
}
