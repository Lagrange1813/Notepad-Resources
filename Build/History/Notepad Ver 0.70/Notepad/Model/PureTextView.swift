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
    var customFont: UIFont! = UIFont(name: "LXGW WenKai", size: 15)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.customize()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customize()
    }
        
    private func customize() {
        self.backgroundColor = ColorCollection.lightBodyBG
        self.textContainerInset = UIEdgeInsets(top: 25, left: 3, bottom: 300, right: 3)
        self.indicatorStyle = .black

        let titleFont = UIFont(name: "LXGW WenKai", size: 18)
        let titleColor = ColorCollection.lightTitleText
        
        let titleParagraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.paragraphSpacing = 20
            style.alignment = .center
            return style
        }()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont!,
            .foregroundColor: titleColor,
            .paragraphStyle: titleParagraphStyle
        ]
        
        let titleString = NSMutableAttributedString(string: title ?? "请输入标题", attributes: titleAttributes)

        let bodyFont = UIFont(name: "LXGW WenKai", size: 15)
        let bodyColor = ColorCollection.lightBodyText
        
        let bodyParagraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7
            style.paragraphSpacing = 14
            style.firstLineHeadIndent = 2 * bodyFont!.pointSize
            style.alignment = .justified
            return style
        }()
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont!,
            .foregroundColor: bodyColor,
            .paragraphStyle: bodyParagraphStyle
//            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        
        let bodyString = NSMutableAttributedString(string: body ?? "请输入正文", attributes: bodyAttributes)
        
        let enter = NSMutableAttributedString(string: "\n")
        titleString.append(enter)
        titleString.append(bodyString)
        
        self.attributedText = titleString

        self.typingAttributes = bodyAttributes
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        
        originalRect.size.height = font!.lineHeight + 2
        originalRect.size.width = 2
        
        return originalRect
    }
    
    func configureText(title: String, body: String) {
        self.title = title
        self.body = body
        self.customize()
    }
}
