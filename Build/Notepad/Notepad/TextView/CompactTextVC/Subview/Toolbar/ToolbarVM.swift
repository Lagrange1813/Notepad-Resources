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
    
    var titleUndoStack = 0
    let titleRedoStack = BehaviorSubject(value: true)
    
    let titleUndoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidCloseUndoGroup, object: textField.titleView.undoManager)
      .map { _ in true }
     
    let titleUndoPop = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidUndoChange, object: textField.titleView.undoManager)
      .map { _ -> Bool in
        titleRedoStack.onNext(true)
        return false
      }
    
    let titleRedoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidRedoChange, object: textField.titleView.undoManager)
      .map { _ -> Bool in
        titleRedoStack.onNext(true)
        return true
      }
    
    let titleCanUndo = Observable
      .merge(titleUndoPush, titleUndoPop, titleRedoPush)
      .map { sign -> Bool in
        if sign == true { titleUndoStack += 1 }
        else if sign == false { titleUndoStack -= 1 }

        if titleUndoStack == 0 { return false }
        else { return true }
      }
      .startWith(false)
    
    let titleCanRedo = titleRedoStack
      .map { _ -> Bool in
        textField.bodyView.undoManager!.canRedo
      }
    
    // MARK: - BodyUndo BodyRedo
    
    var bodyUndoStack = 0
    let bodyRedoStack = BehaviorSubject(value: true)
    
    let bodyUndoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidCloseUndoGroup, object: textField.bodyView.undoManager)
      .map { _ in true }
     
    let bodyUndoPop = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidUndoChange, object: textField.bodyView.undoManager)
      .map { _ -> Bool in
        bodyRedoStack.onNext(true)
        return false
      }
    
    let bodyRedoPush = NotificationCenter.default.rx
      .notification(.NSUndoManagerDidRedoChange, object: textField.bodyView.undoManager)
      .map { _ -> Bool in
        bodyRedoStack.onNext(true)
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
    
    let bodyCanRedo = bodyRedoStack
      .map { _ -> Bool in
        textField.bodyView.undoManager!.canRedo
      }
    
    // MARK: - Merge
    
    let currentTextView = Observable
      .merge(textField.titleView.rx.didBeginEditing.map { 1 },
             textField.bodyView.rx.didBeginEditing.map { 2 })
    
    undoEnabled = Observable.combineLatest(currentTextView, titleCanUndo, bodyCanUndo) { ($0, $1, $2) }
      .map { combine in
        if combine.0 == 1 {
          return combine.1
        } else if combine.0 == 2 {
          return combine.2
        }
        return false
      }
    
    redoEnabled = Observable.combineLatest(currentTextView, titleCanRedo, bodyCanRedo) { ($0, $1, $2) }
      .map { combine in
        if combine.0 == 1 {
          return combine.1
        } else if combine.0 == 2 {
          return combine.2
        }
        return false
      }
    
    // MARK: - Down

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
