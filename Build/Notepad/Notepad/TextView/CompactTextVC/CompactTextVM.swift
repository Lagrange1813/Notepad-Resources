//
//  CompactTextVM.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/25.
//

import UIKit
import RxSwift
import RxCocoa
 
class CompactTextViewModel {
  var currentTheme: Observable<ThemeList>
  
  init() {
    currentTheme = DataManager.shared.currentTheme
  }
}
