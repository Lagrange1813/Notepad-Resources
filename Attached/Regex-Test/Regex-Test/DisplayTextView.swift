//
//  DisplayTextView.swift
//  Regex-Test
//
//  Created by 张维熙 on 2022/6/1.
//

import UIKit

class DisplayTextView: UITextView {

    func refreshStyle(with regexString: String) {
        let wholeRange = NSRange(location: 0, length: text.count)
        
        textStorage.removeAttribute(.foregroundColor, range: wholeRange)
        
        guard let regex = regexString.toRegex() else { return }
        
        textStorage.beginEditing()
        
        regex.enumerateMatches(in: textStorage.string, options: .withoutAnchoringBounds, range: wholeRange) {
            match, flags, stop in
            guard let match = match else { return }
            textStorage.setAttributes([.foregroundColor:UIColor.red], range: match.range)
            
        }
        
        textStorage.edited(.editedAttributes, range: wholeRange, changeInLength: 0)
        textStorage.endEditing()
    }

}

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }

    func toRegex() -> NSRegularExpression? {
        var pattern: NSRegularExpression?

        pattern = try? NSRegularExpression(pattern: self, options: .anchorsMatchLines)

        return pattern
    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
