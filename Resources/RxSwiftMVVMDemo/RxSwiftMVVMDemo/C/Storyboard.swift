//
//  Storyboard.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
   static func instantiate() -> Self?
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self? {
        let fullName = NSStringFromClass(self)
        let classname = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: StoryboardIdentifiers.Main, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: classname) as? Self
    }
}
