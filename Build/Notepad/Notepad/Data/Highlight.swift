//
//  Highlights.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import UIKit

public struct Highlight {
    public enum BuiltIn: String {
        case SimpleLight = "simple-light"
        case SimpleDark = "simple-dark"
        
        public func enable() -> Highlight {
            return Highlight(rawValue)
        }
    }
    
    public var type: String!
    public var titleAttributes: [NSAttributedString.Key: Any]!
    public var bodyAttributes: [NSAttributedString.Key: Any]!
    public var colorSet: [String: UIColor]!
    public var frostedGlass: Bool!
    public var backgroundImage: UIImage?
    
    init(_ name: String) {
        let bundle = Bundle.main
        let path: String!
        
        if let path1 = bundle.path(forResource: "highlights/\(name)", ofType: "json") { path = path1 }
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
        if let textStyles = data["styles"] as? [String: AnyObject] {
            if let titleStyles = textStyles["title"] as? [String: AnyObject] {
                titleAttributes = parse(titleStyles)
            }
            
            if let bodyStyles = textStyles["body"] as? [String: AnyObject] {
                bodyAttributes = parse(bodyStyles)
            }
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
