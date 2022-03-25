//
//  DataManager.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/15.
//

import Foundation
import RxSwift
import RxCocoa

//private let sigleton = DataManager()

class DataManager {
  static var shared: DataManager!
 
  var enabled = false
  
  var theme = BehaviorRelay<Theme>(value: Theme.BuiltIn.Default.enable())
  var currentTheme: Observable<ThemeList>
  
  var highlight = BehaviorRelay<Highlight>(value: Highlight.BuiltIn.SimpleLight.enable())
  
  init(themeMode: Observable<Int>) {
    currentTheme = Observable<ThemeList>.combineLatest(themeMode, theme) {
      var result: ThemeList!
      if $0 == 1 {
        result = $1.main
      } else if $0 == 2 {
        result = $1.secondary
      }
      return result
    }
    
    currentTheme
    .subscribe(onNext: {
      print($0.name)
    })
    .disposed(by: DisposeBag())
  }
}
