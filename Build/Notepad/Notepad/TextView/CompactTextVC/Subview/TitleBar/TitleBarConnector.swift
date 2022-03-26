//
//  TitleBarConnector.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/18.
//

import UIKit
import RxSwift
import RxCocoa

class TitleBarConnector {
  let view: TitleBar!
  private let viewModel: TitleBarViewModel!
  
  init(
    frame: CGRect,
    bag: DisposeBag,
    traitCollection: UITraitCollection,
    functions: (
      listBtn: () -> (),
      listMenu: UIMenu,
      typeBtn: () -> ()
    )
  ) {
    view = TitleBar(frame: frame)
    
    viewModel = TitleBarViewModel(traitCollection: traitCollection)
    
    viewModel.title
      .bind(to: view.title.rx.text)
      .disposed(by: bag)
    
    viewModel.typeBtnText
      .bind(to: view.typeBtn.rx.title())
      .disposed(by: bag)
    
    view.listBtn.rx.tap
      .subscribe(onNext: { functions.listBtn() })
      .disposed(by: bag)

    view.listBtn.menu = functions.listMenu
    
    view.typeBtn.rx.tap
      .subscribe(onNext: { functions.typeBtn() })
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
