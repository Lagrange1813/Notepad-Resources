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
    shortcutFunc: @escaping (CustomBtn) -> (),
    functions: [() -> ()]
  ) {
    view = ToolBar(viewWidth: width, Theme.BuiltIn.TextLight.enable())

    viewModel = ToolbarViewModel(
      textField: textField
    )

    viewModel.undoEnabled
      .bind(to: view.undoBtn.rx.isEnabled)
      .disposed(by: bag)

    
    for button in view.functionalButtons {
      if button.identifier == "redo" {
        viewModel.redoEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
    }

    viewModel.downEnabled
      .bind(to: view.downBtn.rx.isEnabled)
      .disposed(by: bag)

    let dic = fetchButtonTypeDictionary()
    let list = fetchButtonList(with: .Text) as! [String]

    for x in 0 ..< list.count {
      if dic[list[x]] == .ShortcutBtn {
        view.shortcutButtons[x].rx.tap
          .map { self.view.shortcutButtons[x] }
          .subscribe(onNext: {
            shortcutFunc($0)
          })
          .disposed(by: bag)
      } else if dic[list[x]] == .FunctionalBtn {
        view.shortcutButtons[x].rx.tap
          .subscribe(onNext: {
            functions[x]()
          })
          .disposed(by: bag)
      }
    }
  }
}
