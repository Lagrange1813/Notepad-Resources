//
//  ToolbarVM.swift
//  Notepad
//
// Created by 张维熙 on 2022/3/18.
//

import UIKit
import RxSwift
import RxCocoa

class ToolbarViewModel {
  var undoEnabled: Observable<Bool>
//  var pasteEnabled: Observable<Bool>
  var downEnabled: Observable<Bool>

  init(
      titleUndoManager: UndoManager,
      bodyUndoManager: UndoManager
//      pasteBoard: UIPasteboard
  ) {
    let titleCanUndo = Observable.from(optional: titleUndoManager.canUndo)
    let bodyCanUndo = Observable.from(optional: bodyUndoManager.canUndo)
    undoEnabled = Observable.combineLatest(titleCanUndo, bodyCanUndo) { $0 || $1 }
    
    let keyboardShown = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    let keyboardHidden = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)

//    downEnabled = Observable.merge(keyboardShown.map { _ in true }, keyboardHidden.map { _ in false })
//        .startWith(false)
    downEnabled = keyboardShown.map{_ in true}
    
  }
}

