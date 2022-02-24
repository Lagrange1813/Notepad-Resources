//
//  TitleBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/10.
//

import UIKit

class TitleBar: UIView {
    var height: CGFloat!
    
    var listBtn: CustomBtn!
    
    var theme: Theme!
    
    init(frame: CGRect, _ theme: Theme) {
        super.init(frame: frame)
        self.theme = theme
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

        if theme.frostedGlass {
            configureBlur()
        } else {
            backgroundColor = .white
        }
        
        configueTitle()
        configureBtn()
    }
    
    class func height() -> CGFloat {
        return 50
    }
    
    func configureBlur() {
        let backgroundSupport = UIView()
        backgroundSupport.layer.cornerRadius = layer.cornerRadius
        backgroundSupport.clipsToBounds = true
        addSubview(backgroundSupport)
       
        backgroundSupport.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let blur: UIBlurEffect = {
            if traitCollection.userInterfaceStyle == .light {
                return UIBlurEffect(style: .systemUltraThinMaterialLight)
            } else {
                return UIBlurEffect(style: .systemUltraThinMaterialDark)
            }
        }()
        
        let background = UIVisualEffectView(effect: blur)
        background.layer.cornerRadius = layer.cornerRadius
        backgroundSupport.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configueTitle() {
        let text = "卡拉马佐夫兄弟"
        
        let title = UILabel()
        title.text = text
        title.font = fetchFont(font: .bookTitle)

        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(TitleBar.height())
        }
    }
    
    func configureBtn() {
        listBtn = { () -> CustomBtn in
            let button = CustomBtn()
            button.setImage(UIImage(named: "list.bullet.rectangle"), for: .normal)
//            button.tintColor = .white
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
