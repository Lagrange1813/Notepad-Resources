//
//  MDTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/24.
//

import UIKit

class MDTextView: BaseTextView {
    
    override func configureTitleView() {
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
    
    override func customize() {
        super.customize()
        bodyView.typingAttributes = theme.bodyAttributes
        let bodyString = NSMutableAttributedString(string: body ?? "请输入正文", attributes: theme.bodyAttributes)
        bodyView.attributedText = bodyString

        bodyView.selectedRange = NSRange(location: 0, length: 0)
    }
    
    override func correctLayout(width: CGFloat) {
        titleView.snp.updateConstraints { make in
            make.width.equalTo(width - 10)
        }
        bodyView.snp.updateConstraints { make in
            make.width.equalTo(width - 10)
        }
    }
}
