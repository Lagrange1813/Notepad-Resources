//
//  DataManager.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/15.
//

import Foundation

private let sigleton = DataManager()


//enum Type: String {
//  case Text = "TextBtn"
//  case MD = "MDBtn"
//}

class DataManager {
  class var shared: DataManager {
    sigleton
  }

  func initialize() {
    let textBtn = ["indent", "comma", "period", "dayton", "question", "colon", "quotes", "sqrBrackets", "guillemets"]
    let mdBtn = [""]

    userDefaults.set(textBtn, forKey: "TextBtn")
    userDefaults.set(mdBtn, forKey: "MDBtn")
  }

  func fetch(with type: Type) -> NSMutableArray {
    userDefaults.mutableArrayValue(forKey: type.rawValue)
  }
  
  func set(array: NSArray, with type: Type) {
    userDefaults.set(array, forKey: type.rawValue)
  }
  
  
}
