//
//  Extensions.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/23.
//

import Foundation
import UIKit

struct ColorCollection {
    static let bodyBackground = UIColor(red: 0.15686, green: 0.15686, blue: 0.15686, alpha: 1)
    static let bodyText = UIColor(red: 0.90196, green: 0.90196, blue: 0.90196, alpha: 1)
    static let navigation = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let countBackground = UIColor(red: 0.13333, green: 0.13333, blue: 0.13333, alpha: 0.6)
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
