//
//  Text.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/2.
//

import UIKit

class TextClass: NSObject, NSCoding {
    var title: String
    var body: String
    var type: String
    var firstEditTime: Date?
    var lastEditTime: Date?
    
//    var book: BookClass?
    
    init(title: String, body: String, type: String) {
        self.title = title
        self.body = body
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as! String
        self.body = coder.decodeObject(forKey: "body") as! String
        self.type = coder.decodeObject(forKey: "type") as! String
        self.firstEditTime = coder.decodeObject(forKey: "firstEditTime") as? Date
        self.firstEditTime = coder.decodeObject(forKey: "lastEditTime") as? Date
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(type, forKey: "type")
        coder.encode(firstEditTime, forKey: "firstEditTime")
        coder.encode(lastEditTime, forKey: "lastEditTime")
    }
}
