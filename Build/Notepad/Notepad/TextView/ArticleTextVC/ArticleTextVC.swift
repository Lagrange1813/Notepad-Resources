//
//  ArticleTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import UIKit

class ArticleTextVC: CommonTextVC {
    var titleBar: TitleBar!
    var toolBar: ToolBar!

    var isKeyboardHasPoppedUp = false
    var moveDistance: CGFloat?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.supportAll = false
        barHeight = TitleBar.height()
        topPadding = barHeight
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

    func configureStatusBarBackground() {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.topPadding! - 1))
        background.backgroundColor = fetchColor(place: .bodyBG, mode: .light)
        view.addSubview(background)
    }

    func configureTitleBar() {
        titleBar = TitleBar(frame: CGRect(x: view.frame.width/2 - ToolBar.width()/2,
                                          y: ScreenSize.topPadding! + titleBarOffset,
                                          width: ToolBar.width(),
                                          height: TitleBar.height()))
        view.addSubview(titleBar)
    }

    func configureToolBar() {
        toolBar = ToolBar()
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
