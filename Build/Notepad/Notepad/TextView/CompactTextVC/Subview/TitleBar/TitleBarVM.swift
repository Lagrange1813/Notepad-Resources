//
//  TitleBarViewModel.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/18.
//

import RxSwift
import UIKit

class TitleBarViewModel {
  var text: Observable<Text>
  var uuid: Observable<String?>
  var title: Observable<String>
  
  var typeBtnText: Observable<String>
  
  init() {
    uuid = UserDefaults.standard.rx
      .observe(String.self, "CurrentTextID")
    
    text = uuid
      .map { fetchText(UUID(uuidString: $0!)!) }
    
    title = text
      .map { $0.book!.title! }
    
    typeBtnText = UserDefaults.standard.rx
      .observe(String.self, "CurrentTextType")
      .map {
        switch $0! {
        case "Text":
          return "TXT"
        case "MD":
          return "MD"
        default:
          return ""
        }
      }
  }
}
