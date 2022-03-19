//
//  ScrollView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/19.
//

import UIKit

private let userDefaults = UserDefaults.standard

enum Type: String {
  case Text = "TextBtn"
  case MD = "MDBtn"
}

enum ButtonType {
  case null
  case ShortcutBtn
  case FunctionalBtn
}



//let buttonType: [String: ButtonType] = ["redo": .FunctionalBtn,
//                                        "jumpToTop": .FunctionalBtn,
//                                        "jumpToBottom": .FunctionalBtn,
//                                        "indent": .ShortcutBtn,
//                                        "comma": .ShortcutBtn,
//                                        "period": .ShortcutBtn,
//                                        "dayton": .ShortcutBtn,
//                                        "question": .ShortcutBtn,
//                                        "colon": .ShortcutBtn,
//                                        "quotes": .ShortcutBtn,
//                                        "sqrBrackets": .ShortcutBtn,
//                                        "guillemets": .ShortcutBtn]

let buttonType: [String: ButtonType] = fetchButtonTypeDictionary()!

extension ToolBar {
  
  // MARK: - Fetch Instance
  
  func fetchBtnInstance(with name: String) -> CustomBtn {
    switch buttonType[name] {
    case .ShortcutBtn:
      return assembleShortcutBtn(with: name)
    case .FunctionalBtn:
      switch name {
      case "redo": return fetchRedo()
      default: return CustomBtn()
      }
    default:
      return CustomBtn()
    }
  }
  
  // MARK: - Configure Shortcut Button
  
  func fetchShortcutButtonConfigurationPath() -> String {
    let bundle = Bundle.main
    let path: String!
    
    if let path1 = bundle.path(forResource: "toolbar/shortcut-button", ofType: "json") { path = path1 }
    else if let path2 = bundle.path(forResource: "shortcut-button", ofType: "json") { path = path2 }
    else {
      print("Unable to load your button configuration file.")
      assertionFailure()
      return ""
    }
    
    return path
  }
  
  func fetchShortcutButtonConfiguration() -> [String: AnyObject]? {
    let path = fetchShortcutButtonConfigurationPath()
    
    do {
      let json = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
      if let data = json.data(using: .utf8) {
        do {
          return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch let error as NSError {
          print(error)
        }
      }
    } catch let error as NSError {
      print(error)
    }
    
    return nil
  }
  
  func assembleShortcutBtn(with name: String) -> CustomBtn {
    let configuration = fetchShortcutButtonConfiguration()!
    let targetConfig = (configuration[name] as! [String: Any])
    let button = CustomBtn()
    if (targetConfig["image"] as! String) != "" {
      button.setImage(UIImage(systemName: targetConfig["image"] as! String), for: .normal)
    } else {
      button.setTitle(targetConfig["content"] as! String, for: .normal)
      button.setTitleColor(.black, for: .normal)
      button.setTitleColor(.systemGray, for: .highlighted)
      button.titleLabel!.font = UIFont(name: "LXGW WenKai", size: 15)
    }
    button.argument = (targetConfig["content"] as! String)
    button.retreat = (targetConfig["retreat"] as! Int)
    return button
  }
  
  // MARK: - Configure Functional Button
  
  func fetchRedo() -> CustomBtn {
    let button = CustomBtn()
    button.setImage(UIImage(named: "arrowshape.turn.up.right"), for: .normal)
    return button
  }
  
  func fetchJumpToTop() -> CustomBtn {
    let button = CustomBtn()
    
    return button
  }
  
  func fetchJumpToBottom() -> CustomBtn {
    let button = CustomBtn()
    
    return button
  }
}
