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
    functions: (
      listBtn: () -> (),
      listMenu: UIMenu,
      typeBtn: () -> ()
    )
  ) {
    view = TitleBar(frame: frame)
    
    viewModel = TitleBarViewModel()
    
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
    
    DataManager.shared.theme
      .subscribe(onNext: {
        if $0.frostedGlass {
          self.view.configureBlur()
        } else {
          self.view.backgroundColor = $0.colorSet["doubleBarBackground"]
        }
      })
      .disposed(by: bag)
  }
}
