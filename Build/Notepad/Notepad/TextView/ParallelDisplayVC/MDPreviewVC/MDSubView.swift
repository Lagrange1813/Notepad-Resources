//
//  MDSubView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/28.
//

import UIKit
import MarkdownView

class MDSubView: UIScrollView {
    var title: String?
    var body: String? {
        didSet {
            bodyView.load(markdown: body)
        }
    }

    var titleView: CustomTextView!
    var bodyView: MarkdownView!
    
    var theme: Theme!

    init(theme: Theme) {
        super.init(frame: CGRect())
        self.theme = theme
        configureTextView()
        customize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureTextView() {
        configureTitleView()
        configureBodyView()
    }

    func configureTitleView() {
        titleView = CustomTextView()
        titleView.isScrollEnabled = false
        titleView.backgroundColor = .clear
        titleView.sizeToFit()
        addSubview(titleView)

        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(0)
        }
    }

    func configureBodyView() {
        bodyView = MarkdownView()
//        bodyView.isScrollEnabled = false
        bodyView.backgroundColor = .clear
        addSubview(bodyView)

        bodyView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(0)
        }
    }

    func configureText(title: String, body: String) {
        self.title = title
        self.body = body
        customize()
    }

    func customize() {
        titleView.typingAttributes = theme.titleAttributes
        let titleString = NSMutableAttributedString(string: title ?? "请输入标题", attributes: theme.titleAttributes)
        titleView.attributedText = titleString

        titleView.selectedRange = NSRange(location: 0, length: 0)
        
        bodyView.load(markdown: body)
    }

    func resize() {
        contentSize = CGSize(width: frame.width, height: titleView.frame.height + bodyView.frame.height)
    }

    func correctLayout(width: CGFloat) {
        titleView.snp.updateConstraints { make in
            make.width.equalTo(width - 30)
        }
        bodyView.snp.updateConstraints { make in
            make.width.equalTo(width - 10)
        }
    }

    func setInsets(topPadding: CGFloat, bottomPadding: CGFloat) {
        contentInset = UIEdgeInsets(top: topPadding + titleBarOffset, left: 0, bottom: bottomPadding, right: 0)
    }
}
