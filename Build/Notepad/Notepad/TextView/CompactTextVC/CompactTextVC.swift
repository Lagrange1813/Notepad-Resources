//
//  ArticleTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import RxCocoa
import RxSwift
import UIKit

class CompactTextVC: CommonTextVC {
  var viewWidth: CGFloat!
  
  var titleBar: TitleBar!
  var toolBar: ToolBar!
  
  var cursor: UIView?
  var sideCursor: UIView?
  
  var moveDistance: CGFloat?
  
  var trackingView: String?
  
  var isTitleBarHidden: Bool = false
  
  var titleViewUnderEditing = false
  var bodyViewUnderEditing = false
  
  var isShortcutBtnInputing = false
  var retreat: Int = 0
  
  var isMenuExpanded = false
  var isKeyboardUsing = false
  
  var fullScreen = false
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  var image: UIImageView?
  var backgroundSupport: UIView?
  
  var revealSideMenuOnTop = true
  
  var sideMenuRevealWidth: CGFloat = 320
  var sideMenuVC: SideMenuVC!
  var sideMenuShadowView: UIView!
  var isDraggingEnabled: Bool = false
  var isExpanded: Bool = false
  var panBaseLocation: CGFloat = 0.0
  var sideMenuTrailingConstraint: NSLayoutConstraint!
  
  let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preload()
    loadTheme()
    customize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    configureToolBar()
    configureTitleBar()
    
    registNotification()
    
    textField.keyboardDismissMode = .interactive
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    updateViewWidth()
    updateComponents()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
  }
  
  // MARK: - Configure components
  
  func preload() {
    let userDefaults = UserDefaults.standard
//    userDefaults.set("text-light-frosted-glass", forKey: "TextTheme")
    textTheme = Theme(userDefaults.object(forKey: "TextTheme") as! String)
    markdownTheme = Theme(userDefaults.object(forKey: "MDTheme") as! String)
  }
  
  func customize() {
    navigationController?.navigationBar.isHidden = true
    
    appDelegate.supportAll = false
    
    if theme.main.frostedGlass {
      configureBackgroundImage()
      configureBlur()
    } else {
      view.backgroundColor = theme.main.colorSet["background"]
    }
    
    updateViewWidth()
    
    barHeight = TitleBar.height()
    topPadding = barHeight
    bottomPadding = view.frame.height/2
    bottomAnchor = 5
    
    configureSideMenu()
  }
  
//  func configureStatusBarBackground() {
//    let background = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.topPadding! - 1))
//    background.backgroundColor = theme.colorSet["background"]
//    view.addSubview(background)
//  }
  
  func configureBackgroundImage() {
    image = UIImageView(image: UIImage(named: "Qerg85B7JDI"))
    image!.contentMode = .scaleAspectFill
    view.addSubview(image!)
    image!.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configureBlur() {
    backgroundSupport = UIView()
    backgroundSupport!.clipsToBounds = true
    view.addSubview(backgroundSupport!)
    
    backgroundSupport!.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    let blur: UIBlurEffect = {
      if traitCollection.userInterfaceStyle == .light {
        return UIBlurEffect(style: .prominent)
      } else {
        return UIBlurEffect(style: .systemUltraThinMaterialDark)
      }
    }()
    
    let background = UIVisualEffectView(effect: blur)
    backgroundSupport!.addSubview(background)
    
    background.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  
  // MARK: - Optional function
  
  override func remove() {
    guard textField != nil else { return }
    
    super.remove()
    
    toolBar.removeFromSuperview()
    toolBar = nil
    image?.removeFromSuperview()
    image = nil
    backgroundSupport?.removeFromSuperview()
    backgroundSupport = nil
  }
  
  override func firstToLoad() {
    super.firstToLoad()
    preload()
  }
  
  override func secondToLoad() {
    super.secondToLoad()
    if theme.main.frostedGlass {
      configureBackgroundImage()
      configureBlur()
    } else {
      view.backgroundColor = theme.main.colorSet["background"]
    }
  }
  
  override func thirdToLoad() {
    super.thirdToLoad()
    configureToolBar()
    
    registNotification()
  }
  
  enum Position {
    case view
    case textField
    case bodyView
  }
  
  func correctCoordinates(_ location: CGFloat, position: Position) -> CGFloat {
    guard let textField = textField else { return 0 }
    let viewCoordinates = textField.contentOffset
    switch position {
    case .view:
      return location - ScreenSize.topPadding!
    case .textField:
      return location - viewCoordinates.y
    case .bodyView:
      let temp = location + textField.titleView.bounds.height - viewCoordinates.y
      return temp
    }
  }
  
  func updateViewWidth() {
    viewWidth = view.frame.width
  }
  
  func updateComponents() {
    guard let titleBar = titleBar else { return }
    guard let toolBar = toolBar else { return }
    
    let width = viewWidth - 10
    titleBar.frame.size.width = width
    titleBar.frame.origin.x = view.frame.width/2 - width/2
    
    toolBar.viewWidth = viewWidth
    toolBar.snp.updateConstraints { make in
      make.width.equalTo(width)
    }
    toolBar.updateScrollToolView()
  }
}
