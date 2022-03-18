//
//  TitleBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TitleBarConnector {
  let view: TitleBar!
  private let viewModel: TitleBarViewModel!
  
  init(
    frame: CGRect,
    bag: DisposeBag
  ) {
    view = TitleBar(frame: frame, Theme.BuiltIn.TextLight.enable())
    
    viewModel = TitleBarViewModel()
    
    viewModel.title
      .bind(to: view.title.rx.text)
      .disposed(by: bag)
    
    viewModel.typeBtnText
      .bind(to: view.typeBtn.rx.title())
      .disposed(by: bag)
    
//    view.listBtn.rx.tap
//      .subscribe(onNext: { functions.listBtn })
//      .disposed(by: bag)
//
//    view.typeBtn.rx.tap
//      .subscribe(onNext: { functions.typeBtn })
//      .disposed(by: bag)
  }
}
