//
//  TitleBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/10.
//

import UIKit

class TitleBar: UIView {
    var height: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    func customize() {
        height = TitleBar.height()
        backgroundColor = ColorCollection.lightTitleBar
        alpha = 0.95
//        clipsToBounds = true
        
        layer.cornerRadius = 8
        
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1.5
        
        configueTitle()
    }
    
    class func height() -> CGFloat {
        return 50
    }
    
    func configueTitle() {
        let text = "卡拉马佐夫兄弟"
        
        let title = UILabel()
        title.text = text
        title.font = UIFont.systemFont(ofSize: 20)
        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
