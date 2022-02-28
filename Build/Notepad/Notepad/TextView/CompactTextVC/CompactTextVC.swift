//
//  ArticleTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import UIKit

class CompactTextVC: CommonTextVC {
    var viewWidth: CGFloat!

    var titleBar: TitleBar!
    var toolBar: ToolBar!

    var cursor: UIView?
//    var sideCursor: UIView?

    var isKeyboardHasPoppedUp = false
    var moveDistance: CGFloat?

    var trackingView: String?
    
    var isTitleBarHidden: Bool = false

    var titleViewUnderEditing = false
    var bodyViewUnderEditing = false

    var isShortcutBtnInputing = false
    var retreat: Int = 0
//    var prefix = NSRange(location: 0, length: 0)
//    var suffix = NSRange(location: 0, length: 0)

    var isMenuExpanded = false
    var isKeyboardUsing = false

    var fullScreen = false

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var image: UIImageView?
    var backgroundSupport: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTheme = Theme.BuiltIn.TextLightFrostedGlass.enable()
        markdownTheme = Theme.BuiltIn.MarkdownLight.enable()
        loadTheme()
        
        appDelegate.supportAll = false

        if theme.frostedGlass {
            configureBackgroundImage()
            configureBlur()
        } else {
            view.backgroundColor = theme.colorSet["background"]
        }
        
        updateViewWidth()

        barHeight = TitleBar.height()
        topPadding = barHeight
        bottomPadding = view.frame.height/2
        bottomAnchor = 5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureToolBar()
        configureTitleBar()

        registNotification()

        configureTitleBarBtnAction()
        configureToolBarBtnAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUnRedoButtons()
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

    func configureStatusBarBackground() {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.topPadding! - 1))
        background.backgroundColor = theme.colorSet["background"]
        view.addSubview(background)
    }

    func configureTitleBar() {
        titleBar = TitleBar(frame: CGRect(x: view.frame.width/2 - (viewWidth - 10)/2,
                                          y: ScreenSize.topPadding! + titleBarOffset,
                                          width: viewWidth - 10,
                                          height: TitleBar.height()), theme)
        view.addSubview(titleBar)
    }

    func configureToolBar() {
        toolBar = ToolBar(viewWidth: viewWidth, theme)
        view.addSubview(toolBar)

        toolBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if ScreenSize.bottomPadding! > 0 {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
            }
            make.width.equalTo(toolBar.width)
            make.height.equalTo(toolBar.height)
        }

//        toolBar.gestureHandler = { [self] in
//            let pan = self.toolBar.panGestureRecognizer
//            let velocity = pan!.velocity(in: textField).y
//
//            if velocity < -200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y -= 50
//                })
//
//            } else if velocity > 200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y = ScreenSize.topPadding!
//                })
//            }
//        }
    }
    
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
}
