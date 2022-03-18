//
// Created by 张维熙 on 2022/3/18.
//

import UIKit
import RxSwift
import RxCocoa

class ToolbarConnector {
  var view: ToolBar!
  var viewModel: ToolbarViewModel!

  init(
      width: CGFloat,
      bag: DisposeBag,
      titleUndoManager: UndoManager,
      bodyUndoManager: UndoManager,
      functions: [() -> ()]
  ) {
    view = ToolBar(viewWidth: width, Theme.BuiltIn.TextLight.enable())
    
    viewModel = ToolbarViewModel(
      titleUndoManager: titleUndoManager,
      bodyUndoManager: bodyUndoManager
    )
    
    viewModel.undoEnabled
      .bind(to: view.undoBtn.rx.isEnabled)
      .disposed(by: bag)
    
    viewModel.downEnabled
      .bind(to: view.downBtn.rx.isEnabled)
      .disposed(by: bag)
  }
}
