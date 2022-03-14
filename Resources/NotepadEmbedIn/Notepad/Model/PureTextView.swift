//
//  PureTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/24.
//

import UIKit

class PureTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        customize()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
        
    private func customize() {
        self.backgroundColor = ColorCollection.bodyBackground
        self.textContainerInset = UIEdgeInsets(top: 20, left: 3, bottom: 10, right: 3)
        
        let bodyFont = UIFont.systemFont(ofSize: 15)
        let bodyColor = ColorCollection.bodyText
        let bodyParagraphStyle = NSMutableParagraphStyle()
        bodyParagraphStyle.lineSpacing = 7
        bodyParagraphStyle.paragraphSpacing = 14
        bodyParagraphStyle.firstLineHeadIndent = 2 * bodyFont.pointSize
        bodyParagraphStyle.alignment = .justified

        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: bodyColor,
            .paragraphStyle: bodyParagraphStyle,
        ]
        
        self.typingAttributes = bodyAttributes
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        
        originalRect.size.height = font!.lineHeight + 2
        originalRect.size.width = 2
        
        return originalRect
    }
    
    func configureText() {
        
    }
}
