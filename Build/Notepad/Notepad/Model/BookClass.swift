//
//  Book.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/2.
//

import UIKit

class BookClass: NSObject {
    var author: String?
    var firstEditTime: Date?
    var lastEditTime: Date?
    
    var texts: [Text] = []
    
    override init() {
        super.init()
    }
}

