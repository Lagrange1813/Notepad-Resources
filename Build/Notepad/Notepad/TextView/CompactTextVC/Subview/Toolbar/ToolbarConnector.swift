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
    selector: @escaping (String) -> (() -> ())
  ) {
    view = ToolBar(viewWidth: width)

    viewModel = ToolbarViewModel(
      textField: textField
    )

    for button in view.fixedButtons {
      if button.identifier == "command" {
        viewModel.commandEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
      
      if button.identifier == "undo" {
        viewModel.undoEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
      if button.identifier == "paste" {
        viewModel.pasteEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
      if button.identifier == "down" {
        viewModel.downEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
    }
    
    for button in view.functionalButtons {
      if button.identifier == "redo" {
        viewModel.redoEnabled
          .bind(to: button.rx.isEnabled)
          .disposed(by: bag)
      }
    }
    
    for button in view.fixedButtons {
      button.rx.tap
        .map { button }
        .subscribe(onNext: {
          selector($0.identifier!)()
        })
        .disposed(by: bag)
    }

    let dic = fetchButtonTypeDictionary()
    let list = fetchButtonList(with: .Text) as! [String]

    for x in 0 ..< list.count {
      if dic[list[x]] == .ShortcutBtn {
        view.allScrollButtons[x].rx.tap
          .map { self.view.allScrollButtons[x] }
          .subscribe(onNext: {
            shortcutFunc($0)
          })
          .disposed(by: bag)
      } else if dic[list[x]] == .FunctionalBtn {
        view.allScrollButtons[x].rx.tap
          .map { self.view.allScrollButtons[x] }
          .subscribe(onNext: {
            selector($0.identifier!)()
          })
          .disposed(by: bag)
      }
    }
    
    viewModel.keyboardNotification
      .subscribe(onNext: { [self] in
        if $0 {
          view.addShortCutTouchpadButton()
          selector("touchPad")()
        } else {
          view.removeShortCutTouchpadButton()
        }
      })
      .disposed(by: bag)
    
    viewModel.currentTheme
      .subscribe(onNext: {
        if $0.frostedGlass {
          self.view.configureBlur()
          self.view.configureShadow()
        } else {
          self.view.backgroundColor = $0.colorSet["doubleBarBackground"]
          self.view.configureBorder()
        }
      })
      .disposed(by: bag)
    
  }
}
