//
//  TitleBarConnector.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/10.
//

import UIKit

class TitleBar: UIView {
  
  // MARK: - Function
  
  var height: CGFloat!

  var listBtn: CustomBtn!
  var typeBtn: CustomBtn!
  
  var title: UILabel!
  
  // MARK: - Decoration
  
  var backgroundView: UIView!

  // MARK: - Init
  
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

    configureTitle()
    configureBtn()
  }

  class func height() -> CGFloat { 50 }

  func configureTitle() {
    let texts = fetchAllTexts()

    let userDefaults = UserDefaults.standard
    let id = userDefaults.value(forKey: "CurrentTextID") as! String
    var targetText: Text!

    for text in texts {
      if text.id! == UUID(uuidString: id) {
        targetText = text
      }
    }

    let text = targetText.book!.title

    title = UILabel()
    title.text = text
    title.font = UIFont(name: "LXGW WenKai Bold", size: 16)

    insertSubview(title, at: 1)

    title.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(TitleBar.height())
    }
  }

  func configureBtn() {
    listBtn = { () -> CustomBtn in
      let button = CustomBtn()
      button.setImage(UIImage(named: "books.vertical"), for: .normal)
      //            button.tintColor = .white
      insertSubview(button, at: 1)

      button.snp.makeConstraints { make in
        make.width.height.equalTo(25)
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(15)
      }

      return button
    }()

    typeBtn = { () -> CustomBtn in
      let button = CustomBtn()

      button.setTitleColor(.black, for: .normal)
      button.setTitleColor(.systemGray, for: .highlighted)
      button.titleLabel!.font = UIFont(name: "LXGW WenKai", size: 15)
      insertSubview(button, at: 1)

      button.snp.makeConstraints { make in
        make.centerY.equalToSuperview()
        make.trailing.equalToSuperview().inset(30)
        make.width.height.equalTo(35)
      }

      return button
    }()

  }
  
  // MARK: - Decoration
  
  func configureBlur() {
    if backgroundView != nil {
      backgroundView.removeFromSuperview()
      backgroundView = nil
    }

    backgroundView = UIView()
    backgroundView.layer.cornerRadius = layer.cornerRadius
    backgroundView.clipsToBounds = true
    insertSubview(backgroundView, at: 0)

    backgroundView.snp.makeConstraints { make in
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
    backgroundView.addSubview(background)

    background.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  
  func configureShadow() {
    layer.masksToBounds = false
    layer.borderWidth = 0
    layer.borderColor = nil
    
    layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 0.5
  }
  
  func configureBorder() {
    layer.shadowColor = nil
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0
    layer.shadowRadius = 0
    
    layer.masksToBounds = true
    layer.borderWidth = 1.5
    layer.borderColor = UIColor.white.cgColor
  }
}
