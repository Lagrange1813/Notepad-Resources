//
//  TitleBarViewModel.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/18.
//

import Foundation
import RxSwift

class TitleBarViewModel {
  var text: Observable<Text>
  var uuid: Observable<String?>
  var title: Observable<String>
  
  var typeBtnText: Observable<String>
  
  init() {
    uuid = UserDefaults.standard.rx
      .observe(String.self, "CurrentTextID")
    
    text = uuid
      .map { fetchText(UUID.init(uuidString: $0!)!) }
    
    title = text
      .map { $0.title! }
    
    typeBtnText = text
      .map { $0.type! }
    
  }
}
