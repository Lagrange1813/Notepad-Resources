//
//  ToolBarFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit
import RxSwift

extension CompactTextVC {
    func configureToolBar() {
        toolBar = ToolBar(viewWidth: viewWidth, theme)
        view.insertSubview(toolBar, at: 1)

        toolBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if ScreenSize.bottomPadding! > 0 {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
            }
            make.width.equalTo(toolBar.width)
            make.height.equalTo(toolBar.height)
        }

//        toolBar.gestureHandler = { [self] in
//            let pan = self.toolBar.panGestureRecognizer
//            let velocity = pan!.velocity(in: textField).y

//            if velocity < -200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y -= 50
//                })
//
//            } else if velocity > 200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y = ScreenSize.topPadding!
//                })
//            }
//        }
    }
    
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
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .take(until: rx.deallocated)
      .subscribe(onNext: { _ in
        self.configureShortCutTouchPadHandler()
      })
      .disposed(by: bag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .take(until: rx.deallocated)
      .subscribe(onNext: { _ in 
        self.toolBar.removeShortCutTouchpadButton()
      })
      .disposed(by: bag)
  }

    func configureShortCutTouchPadHandler() {
        toolBar.addShortCutTouchpadButton()

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
