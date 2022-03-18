//
//  UIViewController+exsions.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/8/8.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func add(child: UIViewController){
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent:nil)
        removeFromParent()
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
        }
    }
}
