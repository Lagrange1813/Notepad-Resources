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
        case defaultDark = "default-dark"
        
        public func theme() -> Theme {
            return Theme(self.rawValue)
        }
    }
    
    
    public var titleAttributes: [NSAttributedString.Key: Any]!
    public var bodyAttributes: [NSAttributedString.Key: Any]!
    public var colorSet: [String:UIColor]!
    
    init(_ name: String) {
        let bundle = Bundle.main
        let path: String
        
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
    }
    
    mutating func configureEditor(_ attributes: [String: AnyObject]) {
        colorSet = [
            "background": UIColor(hexString: attributes["background"] as! String),
            "counterBackground": UIColor(hexString: attributes["counterBackground"] as! String)
        ]
    }
    
    func parse(_ attributes: [String: AnyObject]) -> [NSAttributedString.Key: Any]? {
        var stringAttributes: [NSAttributedString.Key: Any] = [:]
        
        let paragraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = attributes["lineSpacing"] as! CGFloat
            style.paragraphSpacing = attributes["paragraphSpacing"] as! CGFloat
            style.firstLineHeadIndent = { () -> CGFloat in
                if attributes["firstLineHeadIndent"] as! Bool {
                    return 2*(attributes["size"] as! CGFloat)
                }
                return 0
            }()
            style.alignment = { () -> NSTextAlignment in
                switch attributes["alignment"] as! String {
                case "center": return .center
                case "justfied": return .justified
                default: return .natural
                }
            }()
            return style
        }()
        
        stringAttributes = [
            .font: UIFont(name: attributes["name"] as! String,
                          size: attributes["size"] as! CGFloat)!,
            .foregroundColor: UIColor(hexString: attributes["color"] as! String),
            .paragraphStyle: paragraphStyle
        ]
        
        return stringAttributes
    }
}
