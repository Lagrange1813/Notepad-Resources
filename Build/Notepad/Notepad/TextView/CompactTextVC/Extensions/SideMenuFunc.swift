//
//  SideMenuFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

extension CompactTextVC: UIGestureRecognizerDelegate {
    func configureSideMenu() {
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        
//        let test = UIView(frame: view.bounds)
//        test.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        test.backgroundColor = .white
//        view.insertSubview(test, at: 1)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 2)
        }

        sideMenuVC = SideMenuVC(theme: self.theme)
        addChild(sideMenuVC)
        view.insertSubview(sideMenuVC.view, at: revealSideMenuOnTop ? 3 : 0)
        sideMenuVC.didMove(toParent: self)

        sideMenuVC.textList.delegate = self
        self.sideMenuVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.sideMenuTrailingConstraint = self.sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth)
        self.sideMenuTrailingConstraint.isActive = true

        NSLayoutConstraint.activate([
            self.sideMenuVC.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuVC.view.topAnchor.constraint(equalTo: view.topAnchor),
//            self.sideMenuVC.view.trailingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
//        sideMenuVC.view.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalTo(sideMenuRevealWidth)
//            make.trailing.equalTo(view.snp.leading)
//        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }

    func triggerSideMenu(expand: Bool) {
        if expand {
            textField.titleView.resignFirstResponder()
            textField.bodyView.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
//                self.sideMenuVC.view.snp.updateConstraints { make in
//                    make.trailing.equalTo(self.view.snp.leading).offset(self.sideMenuRevealWidth)
//                }
                self.sideMenuTrailingConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.4 }
            
            self.isExpanded = true
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
//                self.sideMenuVC.view.snp.updateConstraints { make in
//                    make.trailing.equalTo(self.view.snp.leading)
//                }
                self.sideMenuTrailingConstraint.constant = -self.sideMenuRevealWidth
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0 }
            
            self.isExpanded = false
        }
    }
    
    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.triggerSideMenu(expand: false)
        }
    }
    
    @objc func panGestureHandler(sender: UIPanGestureRecognizer) {
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        
//        print(position)
//        print(velocity)
        
        switch sender.state {
        case .began:
            
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }
            
            if velocity > 0, !self.isExpanded {
                self.isDraggingEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging
            else if velocity < 0, self.isExpanded {
                self.isDraggingEnabled = true
            }
            
            if self.isDraggingEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.triggerSideMenu(expand: self.isExpanded ? false : true)
                    self.isDraggingEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }
            
        case .changed:
            
//            print("changed")
            if self.isDraggingEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.4 ? 0.4 : percentage
                    self.sideMenuShadowView.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.4 ? 0.4 : percentage
                        self.sideMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
            
        case .ended:
            
//            print("ended")
            self.isDraggingEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.triggerSideMenu(expand: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.triggerSideMenu(expand: movedMoreThanHalf)
                }
            }
            
        default:
            break
        }
    }
}

extension CompactTextVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let test = sideMenuVC.dataSource.itemIdentifier(for: indexPath)!
        switch test {
        case .section(_):
            break
        case .book(_):
            break
        case .text(let textItem):

            let id = textItem.id.uuidString
            UserDefaults.standard.set(id, forKey: "CurrentTextID")

            restart()
            view.layoutIfNeeded()
            triggerSideMenu(expand: false)

        case .blank(_):
            break
        }
    }
}
