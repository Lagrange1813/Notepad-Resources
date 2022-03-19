//
//  ToolbarVM.swift
//  Notepad
//
// Created by 张维熙 on 2022/3/18.
//

import Combine
import RxCocoa
import RxSwift
import UIKit

class ToolbarViewModel {
  var undoEnabled: Observable<Bool>
  var redoEnabled: Observable<Bool>
//  var pasteEnabled: Observable<Bool>
  var downEnabled: Observable<Bool>

  init(
    textField: BaseTextView
//      pasteBoard: UIPasteboard
  ) {
    
    // MARK: - TitleUndo TitleRedo
    
    let titlePush = NotificationCenter.default.rx
      .notification(.NSUndoManagerWillCloseUndoGroup, object: textField.titleView.undoManager)
      .map { _ in true }
     
    let titlePop = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidUndoChange, object: textField.titleView.undoManager)
      .map { _ in false }
    
    var titleUndoStack = 0
    
    let titleCanUndo = Observable
      .merge(titlePush, titlePop)
      .map { sign -> Bool in
        if sign == true { titleUndoStack += 1 }
        else if sign == false { titleUndoStack -= 1 }
        
        if titleUndoStack == 0 { return false }
        else { return true }
      }
    
    // MARK: - BodyUndo BodyRedo
    
    var bodyUndoStack = 0
    var bodyRedoStack = BehaviorSubject(value: 0)
    
    let bodyUndoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidCloseUndoGroup, object: textField.bodyView.undoManager)
      .map { _ in true }
     
    let bodyUndoPop = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidUndoChange, object: textField.bodyView.undoManager)
      .map { _ -> Bool in
        bodyRedoStack.onNext(try bodyRedoStack.value() + 1)
        return false
      }
    
    let bodyRedoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidRedoChange, object: textField.bodyView.undoManager)
      .map { _ -> Bool in
        bodyRedoStack.onNext(try bodyRedoStack.value() - 1)
        return true
      }
    
    let bodyCanUndo = Observable
      .merge(bodyUndoPush, bodyUndoPop, bodyRedoPush)
      .map { sign -> Bool in
        if sign == true { bodyUndoStack += 1 }
        else if sign == false { bodyUndoStack -= 1 }

        if bodyUndoStack == 0 { return false }
        else { return true }
      }
      .startWith(false)
    
    undoEnabled = bodyCanUndo
    
    let bodyCanRedo = bodyRedoStack
      .map { sign -> Bool in
        return textField.bodyView.undoManager!.canRedo
      }
    
    redoEnabled = bodyCanRedo

    let keyboardShown = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    let keyboardHidden = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)

    downEnabled = Observable.merge(keyboardShown.map { _ in true }, keyboardHidden.map { _ in false })
      .startWith(false)
  }
}

// public extension Reactive where Base: UIImageView {
//  var isHighlighted: ControlEvent<Void> {
//    let source = self.methodInvoked(#selector(setter: Base.isHighlighted)).map { _ in }
//    return ControlEvent(events: source)
//  }
// }
//
// public extension Reactive where Base: UndoManager {
//  var canUndo: ControlEvent<Void> {
//    let source = self.methodInvoked(#selector(getter: Base.canUndo)).map { _ in }
//    return ControlEvent(events: source)
//  }
// }
