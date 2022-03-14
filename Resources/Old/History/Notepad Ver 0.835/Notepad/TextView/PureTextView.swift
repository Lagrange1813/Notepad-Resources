//
//  PureTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/24.
//

import UIKit

class PureTextView: UIScrollView, UITextViewDelegate {
    var title: String?
    var body: String?
    
    var titleFont: UIFont!
    var bodyFont: UIFont!
    
    var titleView: CustomTextView!
    var bodyView: CustomTextView!
    
    var titleViewUnderEditing = false
    var bodyViewUnderEditing = false
    
    var isShortcutBtnInputing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBackView()
        configureTextView()
        configureFont(fontName: "LXGW WenKai")
        customize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBackView()
        configureTextView()
        configureFont(fontName: "LXGW WenKai")
        customize()
    }
    
    func configureBackView() {
        self.backgroundColor = .white
        self.indicatorStyle = .black
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
        self.alwaysBounceHorizontal = false
    }
    
    func configureTextView() {
        titleView = CustomTextView()
        titleView.isScrollEnabled = false
        titleView.textAlignment = .center
        titleView.delegate = self
        titleView.sizeToFit()
        addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        bodyView = CustomTextView()
        bodyView.isScrollEnabled = false
        addSubview(bodyView)
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(ScreenSize.width - 10)
        }
    }
    
    func configureFont(fontName: String) {
        titleFont = UIFont(name: fontName, size: 20)
        bodyFont = UIFont(name: fontName, size: 15)
    }
    
    private func customize() {
        let titleFont = titleFont
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
        
        titleView.typingAttributes = titleAttributes
        let titleString = NSMutableAttributedString(string: title ?? "请输入标题", attributes: titleAttributes)
        titleView.attributedText = titleString
        
        let bodyFont = bodyFont
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
        ]
        
        bodyView.typingAttributes = bodyAttributes
        let bodyString = NSMutableAttributedString(string: body ?? "请输入正文", attributes: bodyAttributes)
        bodyView.text = body
    }

    func configureText(title: String, body: String) {
        self.title = title
        self.body = body
        self.customize()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        titleView.sizeToFit()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            bodyView.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func resize() {
        contentSize = CGSize(width: frame.width, height: titleView.frame.height + bodyView.frame.height)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        titleViewUnderEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        titleViewUnderEditing = false
    }
    
}
