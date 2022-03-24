//
//  DataManager.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/15.
//

import Foundation
import RxSwift
import RxCocoa

private let sigleton = DataManager()

class DataManager {
  class var shared: DataManager {
    sigleton
  }

  var themeMode: Observable<Int>!
  var theme = BehaviorRelay<Theme>(value: Theme.BuiltIn.DefaultLight.enable())
  var highlight = BehaviorRelay<Highlight>(value: Highlight.BuiltIn.SimpleLight.enable())
  
}
