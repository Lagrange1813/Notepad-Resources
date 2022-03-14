//
//  PureTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/24.
//

import UIKit

class PureTextView: UITextView, UITextFieldDelegate {
//    var title: UITextField!
//    var textStorage: NSTextStorage
//    var layoutManager: NSLayoutManager
//    var textContainer: NSTextContainer
    var title: String?
    var body: String?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.customize()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customize()
    }
        
    func customize() {
        self.backgroundColor = ColorCollection.bodyBackground
        self.textContainerInset = UIEdgeInsets(top: 20, left: 3, bottom: 10, right: 3)
        
        let titleFont = UIFont.systemFont(ofSize: 18)
        let titleColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        titleParagraphStyle.paragraphSpacing = 9
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor,
            .paragraphStyle: titleParagraphStyle
        ]
        
        let titleString = NSMutableAttributedString(string: title ?? "请输入标题", attributes: titleAttributes)

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
            .paragraphStyle: bodyParagraphStyle
//            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        
        let bodyString = NSMutableAttributedString(string: body ?? "请输入正文", attributes: bodyAttributes)
        
        let enter = NSMutableAttributedString(string: "\n")
        titleString.append(enter)
        titleString.append(bodyString)
        
        self.attributedText = titleString

//        let bodyFont = UIFont.systemFont(ofSize: 15)
//        let bodyColor = ColorCollection.bodyText
//        let bodyParagraphStyle = NSMutableParagraphStyle()
//        bodyParagraphStyle.lineSpacing = 7
//        bodyParagraphStyle.paragraphSpacing = 14
//        bodyParagraphStyle.firstLineHeadIndent = 2 * bodyFont.pointSize
//        bodyParagraphStyle.alignment = .justified
//
//        let bodyAttributes: [NSAttributedString.Key: Any] = [
//            .font: bodyFont,
//            .foregroundColor: bodyColor,
//            .paragraphStyle: bodyParagraphStyle
//        ]
//        
//        self.typingAttributes = bodyAttributes
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        
        originalRect.size.height = font!.lineHeight + 2
        originalRect.size.width = 2
        
        return originalRect
    }
    
    func configureText() {}
}
