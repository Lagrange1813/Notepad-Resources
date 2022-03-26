//
//  NewCompactVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/25.
//

import UIKit
import RxSwift
import RxCocoa

extension CompactTextVC {
  func customize() {
    navigationController?.navigationBar.isHidden = true
    
    appDelegate.supportAll = false
    
    updateViewWidth()
    
    barHeight = TitleBar.height()
    topPadding = barHeight
    bottomPadding = view.frame.height/2
    bottomAnchor = 5
    
    configureSideMenu()
    
    viewModel.currentTheme
      .subscribe(onNext: {
        if $0.frostedGlass {
          self.configureBackgroundImage(with: $0.backgroundImage!)
          self.configureBlur()
        } else {
          self.view.backgroundColor = $0.colorSet["background"]
        }
      })
      .disposed(by: bag)
  }
  
  func configureBackgroundImage(with image: UIImage) {
    if backgroundImage != nil {
      backgroundImage!.removeFromSuperview()
      backgroundImage = nil
    }
    
    backgroundImage = UIImageView(image: image)
    backgroundImage!.contentMode = .scaleAspectFill
    view.insertSubview(backgroundImage!, at: 0)
    backgroundImage!.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configureBlur() {
    if backgroundView != nil {
      for view in backgroundView!.subviews {
        view.removeFromSuperview()
      }
      backgroundView!.removeFromSuperview()
      backgroundView = nil
    }
    
    backgroundView = UIView()
    backgroundView!.clipsToBounds = true
    view.insertSubview(backgroundView!, at: 1)
    
    backgroundView!.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    let blur: UIBlurEffect = {
      if traitCollection.userInterfaceStyle == .light {
        return UIBlurEffect(style: .systemMaterialLight)
      } else {
        return UIBlurEffect(style: .systemUltraThinMaterialDark)
      }
    }()
    
    let background = UIVisualEffectView(effect: blur)
    backgroundView!.addSubview(background)
    
    background.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
}
