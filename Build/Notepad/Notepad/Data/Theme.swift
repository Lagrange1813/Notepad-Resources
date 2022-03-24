//
//  Theme.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/23.
//

import UIKit

public struct Theme {
  public enum BuiltIn: String {
    case DefaultLight = "default-light"
    case DefaultDark = "default-dark"
    case TextLight = "text-light"
    case TextDark = "text-dark"
    case TextLightFrostedGlass = "text-light-frosted-glass"
    case TextDarkFrostedGlass = "text-dark-frosted-glass"
    case MarkdownLight = "md-light"
    case MarkdownDark = "md-dark"
    case MarkdownLightFrostedGlass = "md-light-frosted-glass"
    case MarkdownDarkFrostedGlass = "md-dark-frosted-glass"
    
    public func enable() -> Theme {
      Theme(rawValue)
    }
  }
  
//  public var type: String!
  public var titleAttributes: [NSAttributedString.Key: Any]!
  public var bodyAttributes: [NSAttributedString.Key: Any]!
  public var colorSet: [String: UIColor]!
  public var frostedGlass: Bool!
  public var backgroundImage: UIImage?
  public var relativeTheme: String!
  public var highlight: Highlight?
  
  init(_ name: String) {
    let bundle = Bundle.main
    let path: String!
    
    if let path1 = bundle.path(forResource: "themes/\(name)", ofType: "json") { path = path1 }
    else if let path2 = bundle.path(forResource: name, ofType: "json") { path = path2 }
    else {
      print("Unable to load your theme file.")
      assertionFailure()
      return
    }
    
    if let data = convertFile(path) {
      configure(data)
    }
  }
  
  func convertFile(_ path: String) -> [String: AnyObject]? {
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
  
  mutating func configure(_ data: [String: AnyObject]) {
    if let editorStyles = data["editor"] as? [String: AnyObject] {
      configureEditor(editorStyles)
    }
    
    if let textStyles = data["styles"] as? [String: AnyObject] {
      if let titleStyles = textStyles["title"] as? [String: AnyObject] {
        titleAttributes = parse(titleStyles)
      }
      
      if let bodyStyles = textStyles["body"] as? [String: AnyObject] {
        bodyAttributes = parse(bodyStyles)
      }
    }
    
    if let relativeTheme = data["relativeTheme"] as? String {
      self.relativeTheme = relativeTheme
    }
    
    if let highlightStyle = data["highlight"] as? String {
      highlight = Highlight(highlightStyle)
    }
  }
  
  mutating func configureEditor(_ attributes: [String: AnyObject]) {
//    type = (attributes["type"] as! String)
    
    colorSet = [
      "background": UIColor(hexString: attributes["background"] as! String),
      "counterText": UIColor(hexString: attributes["counterText"] as! String),
      "counterBackground": UIColor(hexString: attributes["counterBackground"] as! String),
    ]
    
    frostedGlass = (attributes["frostedGlass"] as! Bool)
    
    if frostedGlass {
      backgroundImage = UIImage(named: attributes["backgroundImage"] as! String)!
    } else {
      colorSet.updateValue(UIColor(hexString: attributes["doubleBarText"] as! String), forKey: "doubleBarText")
      colorSet.updateValue(UIColor(hexString: attributes["doubleBarBackground"] as! String), forKey: "doubleBarBackground")
    }
  }
  
  func parse(_ attributes: [String: AnyObject]) -> [NSAttributedString.Key: Any]? {
    var stringAttributes: [NSAttributedString.Key: Any] = [:]
    
    let paragraphStyle: NSMutableParagraphStyle = {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = attributes["lineSpacing"] as! CGFloat
      style.paragraphSpacing = attributes["paragraphSpacing"] as! CGFloat
      style.firstLineHeadIndent = { () -> CGFloat in
        if attributes["firstLineHeadIndent"] as! Bool {
          return 2 * (attributes["size"] as! CGFloat)
        }
        return 0
      }()
      style.alignment = { () -> NSTextAlignment in
        switch attributes["alignment"] as! String {
        case "center": return .center
        case "justified": return .justified
        case "left": return .left
        case "right": return .right
        default: return .natural
        }
      }()
      return style
    }()
    
    stringAttributes = [
      .font: UIFont(name: attributes["name"] as! String,
                    size: attributes["size"] as! CGFloat) ?? UIFont.systemFont(ofSize: attributes["size"] as! CGFloat),
      .foregroundColor: UIColor(hexString: attributes["color"] as! String),
      .paragraphStyle: paragraphStyle,
    ]
    
    return stringAttributes
  }
}
