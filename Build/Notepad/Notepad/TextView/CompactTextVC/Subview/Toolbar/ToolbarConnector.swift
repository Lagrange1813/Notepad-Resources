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
      frame: CGRect,
      bag: DisposeBag,
      functions: [() -> ()]
  ) {

  }
}