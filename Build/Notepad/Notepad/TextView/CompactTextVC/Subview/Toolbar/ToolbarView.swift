//
//  ToolBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import SnapKit
import UIKit

class ToolBar: UIView {
  var viewWidth: CGFloat = 0 {
    didSet {
      width = viewWidth - 10
    }
  }
  
  let btnLength = 20.0
  let btnSpacing = 10.0
  
  var width: CGFloat!
  var height = 40.0
  
  var panGestureRecognizer: UIPanGestureRecognizer!
  var gestureHandler: (() -> ())?
  
  var scrollToolView: CustomScrollView!
  
  var commandBtn: CustomBtn!
  
  var touchPad: TouchPad!
  
  var undoBtn: CustomBtn!
  var pasteBtn: CustomBtn!
  var touchPadBtn: TouchPad?
  var downBtn: CustomBtn!
  
  // MARK: - ScrollView
  var shortcutButtons: [CustomBtn] = []
  
  var redoBtn: CustomBtn?
  
  var quotesBtn: CustomBtn?
  var sqrBracketsBtn: CustomBtn?
  var bracketsBtn: CustomBtn?
  
  var jumpToTop: CustomBtn?
  var jumpToBottom: CustomBtn?
  
  var theme: Theme!
  
  let fixedBarItem = ("command", "arrowshape.turn.up.backward", "doc.on.clipboard", "keyboard.chevron.compact.down")
  
  init(viewWidth: CGFloat, _ theme: Theme) {
    super.init(frame: CGRect())
    self.viewWidth = viewWidth
    self.theme = theme
    customize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customize()
  }
  
  func customize() {
    width = viewWidth - 10
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan))
    
    alpha = 1
    tintColor = .black
    layer.cornerRadius = 10
    
//    layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//    layer.shadowOffset = CGSize(width: 0, height: 0)
//    layer.shadowOpacity = 0.5
//    layer.shadowRadius = 0.5
    
    layer.masksToBounds = true
    layer.borderWidth = 1.5
    layer.borderColor = UIColor.white.cgColor
    
    if theme.frostedGlass {
      configureBlur()
    } else {
      backgroundColor = theme.colorSet["doubleBarBackground"]
    }
    
    configureScrollToolView()
    configureFixedButton()
    configureScrollViewButton()
    
    //        changeToDark()
  }
  
  @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
    gestureHandler?()
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
  
  func configureScrollToolView() {
    scrollToolView = { () -> CustomScrollView in
      let view = CustomScrollView(frame: CGRect(x: height * 4 + 2 + 2, y: 0, width: width - height * 5 - 2.0, height: height))
      view.alpha = 1
      view.contentSize = CGSize(width: 10 * height, height: height)
      view.canCancelContentTouches = true
      view.delaysContentTouches = false
      view.showsHorizontalScrollIndicator = false
      return view
    }()
    addSubview(scrollToolView)
  }
  
  func updateScrollToolView() {
    scrollToolView.frame.size.width = width - height * 5 - 2.0 - 2.0
  }
  
  func configureFixedButton() {
    commandBtn = { () -> CustomBtn in
      let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
      button.setImage(UIImage(named: fixedBarItem.0), for: .normal)
      addSubview(button)
      
      return button
    }()
    
    undoBtn = { () -> CustomBtn in
      let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 1 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
      button.setImage(UIImage(named: fixedBarItem.1), for: .normal)
      button.setTitleColor(.black, for: .normal)
      addSubview(button)
      
      return button
    }()
    
    pasteBtn = { () -> CustomBtn in
      let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
      button.setImage(UIImage(named: fixedBarItem.2), for: .normal)
      addSubview(button)
      
      return button
    }()
    
    configureShortCutTouchpad()
    
    downBtn = { () -> CustomBtn in
      let button = CustomBtn()
      button.setImage(UIImage(named: fixedBarItem.3), for: .normal)
      addSubview(button)
      
      button.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(height / 2 - btnLength / 2)
        make.trailing.equalToSuperview().inset(2 + btnLength / 2)
        make.width.height.equalTo(btnLength)
      }
      
      return button
    }()
    
    let dividingLineHeight: CGFloat = 26
    let dividingLine = UIView(frame: CGRect(x: height * 4 + 2 + 1, y: height / 2 - dividingLineHeight / 2, width: 1, height: dividingLineHeight))
    dividingLine.backgroundColor = .gray
    dividingLine.alpha = 0.4
    addSubview(dividingLine)
  }
  
  func configureShortCutTouchpad() {
    let iconHeight = btnLength - 3.5
    let buttonIcon = UIImageView(frame: CGRect(x: height / 2 - btnLength / 2 + height * 3 + 2, y: height / 2 - iconHeight / 2, width: btnLength, height: iconHeight))
    buttonIcon.image = UIImage(systemName: "ipad.landscape")
    addSubview(buttonIcon)
  }
  
  func addShortCutTouchpadButton() {
    touchPadBtn = TouchPad(x: height * 3 + 2, y: 0, width: height, height: height)
    addSubview(touchPadBtn!)
  }
  
  func removeShortCutTouchpadButton() {
    touchPadBtn?.removeFromSuperview()
    touchPadBtn = nil
  }
  
  func addToView(at index: Int, with button: CustomBtn) {
    let jumpSpacing: CGFloat = 35.0
    scrollToolView.addSubview(button)
    button.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalTo(height / 2 + jumpSpacing * CGFloat(index))
      make.size.width.height.equalTo(30)
    }
  }
  
  func configureScrollViewButton() {
    let btnList = fetchButtonList(with: .Text) as! [String]
    
    for x in 0 ..< btnList.count {
      let instance = fetchBtnInstance(with: btnList[x])
      shortcutButtons.append(instance)
      addToView(at: x, with: instance)
    }
  }
  
  func configureTouchPad(_ commandHeight: CGFloat) {
    let touchPadWidth: CGFloat = commandHeight - 50
    let touchPadHeight: CGFloat = commandHeight - 50
    
    touchPad = TouchPad(x: width / 2 - CGFloat(touchPadWidth / 2), y: height + commandHeight / 2 - touchPadHeight / 2, width: touchPadWidth, height: touchPadHeight)
    
    addSubview(touchPad)
    
    let icon = UIImageView(image: UIImage(systemName: "ipad.landscape"))
    touchPad.addSubview(icon)
    icon.snp.makeConstraints { make in
      make.width.equalTo(20)
      make.height.equalTo(20)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-7)
    }
    
    touchPad.isHidden = true
  }
  
//  override func touchesBegan(_ touches: Set<UITouch>?, with event: UIEvent!) {
//    lastLocation = center
//    print("start!")
//
//    tracking = true
//    velocityLoop = CADisplayLink(target: self, selector: #selector(watching))
//    velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
//  }
//
//  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    print("moving!")
//  }
//
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    print("ended!")
//    tracking = false
//  }
//
//  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    print("cancelled!")
//    //        tracking = false
//  }
}
