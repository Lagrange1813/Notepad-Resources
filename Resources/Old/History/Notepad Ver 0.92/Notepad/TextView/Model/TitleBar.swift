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
        tintColor = .black
        alpha = 1
        
        layer.cornerRadius = 8
        
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.5

        configureBlur()
        configueTitle()
        configureBtn()
    }
    
    class func height() -> CGFloat {
        return 50
    }
    
    func configureBlur() {
        let backgroundSupport = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundSupport.layer.cornerRadius = layer.cornerRadius
        backgroundSupport.clipsToBounds = true
        addSubview(backgroundSupport)
        
        let blur = UIBlurEffect(style: .light)
        let background = UIVisualEffectView(effect: blur)
        background.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        background.layer.cornerRadius = layer.cornerRadius
        backgroundSupport.addSubview(background)
    }
    
    func configueTitle() {
        let text = "卡拉马佐夫兄弟"
        
        let title = UILabel()
        title.text = text
        title.font = getFont(font: .bookTitle)

        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(TitleBar.height())
        }
    }
    
    func configureBtn() {
        let listBtn: UIButton = {
            let button = CustomBtn()
            button.setImage(UIImage(named: "list.bullet.rectangle"), for: .normal)
            addSubview(button)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(15)
            }
            
            return button
        }()
    }
}
