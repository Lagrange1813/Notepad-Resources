//
//  AutoResponse.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/10.
//

import UIKit

extension CompactTextVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let textField = textField else { return }
        if textView == textField.bodyView {
            bodyViewUnderEditing = true
            trackingView = "body"
        } else if textView == textField.titleView {
            titleViewUnderEditing = true
            trackingView = "title"
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == textField.bodyView {
            bodyViewUnderEditing = false
        } else if textView == textField.titleView {
            titleViewUnderEditing = false
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if isShortcutBtnInputing {
            isShortcutBtnInputing = false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !fullScreen {
            let pan = scrollView.panGestureRecognizer
            let velocity = pan.velocity(in: scrollView).y

            if velocity < -200 {
                hideTitleBar()
//                navigationController?.prefersStatusBarHidden = true

            } else if velocity > 200 {
                showTitleBar()
            }

            if textField.contentOffset.y <= -(TitleBar.height() + titleBarOffset) + 10 {
                showTitleBar()
            }
        }
    }

    func registNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if !isMenuExpanded {
            let keyboardInfo = notification.userInfo as NSDictionary?
            let value = keyboardInfo?.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
            let distance = value.height - ScreenSize.bottomPadding! + 5
            moveDistance = distance
            isKeyboardHasPoppedUp = true

            UIView.animate(withDuration: 1, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(distance)
                }
            })
            view.layoutIfNeeded()

        } else {
            UIView.animate(withDuration: 1, animations: {
                self.toolBar.snp.updateConstraints { make in
                    make.height.equalTo(40)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(self.moveDistance!)
                }
            })
            view.layoutIfNeeded()

            textField.bodyView.becomeFirstResponder()
        }

        if let cursor = cursor {
            cursor.removeFromSuperview()
            self.cursor = nil
        }

        isKeyboardUsing = true
        isMenuExpanded = false

        updateBtnStatus()
    }

    @objc func handleKeyboardWillHide() {
        if !isMenuExpanded {
            UIView.animate(withDuration: 1, animations: {
                self.toolBar.snp.updateConstraints { make in
                    if ScreenSize.bottomPadding! > 0 {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    } else {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(5)
                    }
                }
            })
            view.layoutIfNeeded()
        }

        isKeyboardUsing = false

        updateBtnStatus()
    }
}
