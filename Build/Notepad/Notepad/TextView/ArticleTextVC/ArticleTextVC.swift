//
//  ArticleTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import UIKit

class ArticleTextVC: CommonTextVC {
    var viewWidth: CGFloat!

    var titleBar: TitleBar!
    var toolBar: ToolBar!

    var cursor: UIView?

    var isKeyboardHasPoppedUp = false
    var moveDistance: CGFloat?

    var trackingView: String?

    var titleViewUnderEditing = false
    var bodyViewUnderEditing = false

    var isShortcutBtnInputing = false

    var isMenuExpanded = false
    var isKeyboardUsing = false

    var fullScreen = false

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.supportAll = false

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
//            let velocity = pan!.velocity(in: articleField).y
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
}
