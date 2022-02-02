//
//  CustomTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/28.
//

import UIKit

class CustomTextView: UITextView {
    var identifier: String!

    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)

        originalRect.size.height = font!.lineHeight + 2
        originalRect.size.width = 2

        return originalRect
    }

    public func getRangeRect(_ textView: CustomTextView, _ range: NSRange) -> CGRect {
        let beginning = textView.beginningOfDocument

        guard let start = textView.position(from: beginning, offset: range.location) else {
            return .zero
        }
        guard let end = textView.position(from: start, offset: range.length) else {
            return .zero
        }

        guard let textRange = textView.textRange(from: start, to: end) else {
            return .zero
        }

        return textView.firstRect(for: textRange)
    }
}
