//
//  SideMenuFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

extension CompactTextVC {
    func configureSideMenu() {
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        tapGestureRecognizer.delegate = self
//        view.addGestureRecognizer(tapGestureRecognizer)
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }

        sideMenuVC = SideMenuVC()
        addChild(sideMenuVC)
        view.insertSubview(sideMenuVC.view, at: (revealSideMenuOnTop ? 2 : 0))
        sideMenuVC.didMove(toParent: self)

        sideMenuVC.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(sideMenuRevealWidth)
            make.trailing.equalTo(view.snp.leading)
        }
    }
}
