//
//  AutoResponse.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/10.
//

import UIKit

extension CurrentTextVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == articleField.bodyView {
            articleField.bodyViewUnderEditing = true
            articleField.trackingView = "body"
        } else if textView == articleField.titleView {
            articleField.titleViewUnderEditing = true
            articleField.trackingView = "title"
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == articleField.bodyView {
            articleField.bodyViewUnderEditing = false
        } else if textView == articleField.titleView {
            articleField.titleViewUnderEditing = false
        }
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pan = scrollView.panGestureRecognizer
//        let velocity = pan.velocity(in: scrollView).y
//        navigationController?.navigationBar.barStyle = .black
//        if velocity < -200 {
//            UIView.animate(withDuration: 0.3, animations: {
////                self.navigationController?.isNavigationBarHidden = true  WOC, NB!
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//            })
////            navigationController?.isNavigationBarHidden = true
//        } else if velocity > 200 {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.navigationController?.isNavigationBarHidden = false
//            })
//        }
//    }

    func registNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if !articleField.isMenuExpanded {
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

            articleField.bodyView.becomeFirstResponder()
        }

        if let cursor = cursor {
            cursor.removeFromSuperview()
            self.cursor = nil
        }

        articleField.isKeyboardUsing = true
        articleField.isMenuExpanded = false

        updateBtnStatus()
    }

    @objc func handleKeyboardWillHide() {
        if !articleField.isMenuExpanded {
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

        articleField.isKeyboardUsing = false

        updateBtnStatus()
    }
}
