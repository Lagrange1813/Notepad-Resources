//
// Created by 张维熙 on 2022/3/18.
//

import RxCocoa
import RxSwift
import UIKit

class ToolbarConnector {
  var view: ToolBar!
  var viewModel: ToolbarViewModel!

  init(
    width: CGFloat,
    bag: DisposeBag,
    textField: BaseTextView,
    functions: [() -> ()]
  ) {
    view = ToolBar(viewWidth: width, Theme.BuiltIn.TextLight.enable())

    viewModel = ToolbarViewModel(
      textField: textField
    )

    viewModel.undoEnabled
      .bind(to: view.undoBtn.rx.isEnabled)
      .disposed(by: bag)

    if let redoBtn = view.redoBtn {
      viewModel.redoEnabled
        .bind(to: redoBtn.rx.isEnabled)
        .disposed(by: bag)
    }

    viewModel.downEnabled
      .bind(to: view.downBtn.rx.isEnabled)
      .disposed(by: bag)
  }
  
  
}
