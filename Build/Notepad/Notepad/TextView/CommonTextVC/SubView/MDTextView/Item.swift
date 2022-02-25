//
//  Item.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import Foundation

public enum Item: String {
    case unknown = "x^"

    case h1 = "^(\\#[^\\#](.*))$"
    case h2 = "^(\\#{2}(.*))$"
    case h3 = "^(\\#{3}(.*))$"

    case body = ".*"

    case bold = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"
    case italic = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)"
    case boldItalic = "(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)"
    case code = "(`[^`]{1,}`)"

    case url = "\\[([^\\]]+)\\]\\(([^\\)\"\\s]+)(?:\\s+\"(.*)\")?\\)"
    case image = "\\!\\[([^\\]]+)\\]\\(([^\\)\"\\s]+)(?:\\s+\"(.*)\")?\\)"
    
    func toRegex() -> NSRegularExpression {
        return self.rawValue.toRegex()
    }
}
