//
//  ToolbarBtnFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/21.
//

import UIKit

extension CompactTextVC {
  
  // MARK: - Fixed Button Functions
  
  func commandBtnFunc() {
      if isKeyboardUsing {
          // 此时键盘展开，点击收起键盘并展示command菜单
          isMenuExpanded = true
          isKeyboardUsing = false

          updateBtnStatus()

          textField.titleView.resignFirstResponder()
          textField.bodyView.resignFirstResponder()

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

      } else if !isMenuExpanded, !isKeyboardUsing {
          // 此时键盘收起，点击展开展示command菜单
          isMenuExpanded = true
          isKeyboardUsing = false

          updateBtnStatus()

          UIView.animate(withDuration: 0.5, animations: {
              self.toolBar.snp.updateConstraints { make in
                  make.height.equalTo(self.moveDistance! + 40)
              }
              self.view.layoutIfNeeded()
          })

          configureTouchPadHandler()

      } else if isMenuExpanded {
          // 此时command菜单展开，点击收起菜单，恢复键盘
          isMenuExpanded = false
          isKeyboardUsing = true

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

          textField.bodyView.becomeFirstResponder()
          if let cursor = cursor {
              cursor.removeFromSuperview()
              self.cursor = nil
          }
      }
  }

  func configureTouchPadHandler() {
      guard let touchPad = toolBar.touchPad else { return }

      touchPad.isHidden = false

      var rectFrame = textField.bodyView.fetchRect(textField.bodyView, textField.bodyView.selectedRange)

      cursor = UIView(frame: rectFrame)
      cursor!.backgroundColor = UIColor(red: 0.2941176, green: 0.415686, blue: 0.917647, alpha: 1)
      textField.bodyView.addSubview(cursor!)

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

          if downSide >= textField.bodyView.frame.height {
              cursor!.frame.origin.y = textField.bodyView.frame.height - cursor!.frame.height
          }

          if rightSide >= textField.bodyView.frame.width {
              cursor!.frame.origin.x = textField.bodyView.frame.width - cursor!.frame.width
          }

          let upperSurface = correctCoordinates(cursor!.frame.origin.y, position: .bodyView)
          let lowerSurface = upperSurface + cursor!.frame.height

          let upperBoundary: CGFloat = 0
          let lowerBoundary = correctCoordinates(toolBar.frame.origin.y, position: .view) - 30

          if upperSurface <= upperBoundary {
              textField.setContentOffset(CGPoint(x: 0,
                                                 y: textField.contentOffset.y - 5), animated: false)
              cursor!.frame.origin.y -= 4
              hideTitleBar()
          }

          if lowerSurface >= lowerBoundary {
              textField.setContentOffset(CGPoint(x: 0, y: textField.contentOffset.y + 5), animated: false)
              hideTitleBar()
          }
      }

      touchPad.handleTouchEnded = { [unowned self] in
          print("ended")
          let range = self.textField.bodyView.closestPosition(to: self.cursor!.center)!
          let location = self.textField.bodyView.offset(from: textField.bodyView.beginningOfDocument, to: range)
          textField.bodyView.selectedRange = NSRange(location: location, length: 0)

          rectFrame = textField.bodyView.fetchRect(textField.bodyView, textField.bodyView.selectedRange)
          cursor!.frame = rectFrame
      }
  }

  

  func pasteBtnFunc() {
      let pasteBoard = UIPasteboard.general
      guard let dataToPaste = pasteBoard.string else { return }
      toolBar.pasteBtn.argument = dataToPaste
      toolBar.pasteBtn.addTarget(self, action: #selector(insertFromCursor), for: .touchUpInside)
  }

  func downBtnFunc() {
      textField.titleView.resignFirstResponder()
      textField.bodyView.resignFirstResponder()
      isShortcutBtnInputing = false
      titleViewUnderEditing = false
      bodyViewUnderEditing = false
  }
  
  // MARK: - ScrollView Button Functions
  
  func undoFunc() {
    if trackingView == "body" {
      textField.bodyView.undoManager?.undo()
    } else if trackingView == "title" {
      textField.titleView.undoManager?.undo()
    }
  }
  
  func redoFunc() {
      if trackingView == "body" {
          textField.bodyView.undoManager?.redo()
      } else if trackingView == "title" {
          textField.titleView.undoManager?.redo()
      }
  }
}
