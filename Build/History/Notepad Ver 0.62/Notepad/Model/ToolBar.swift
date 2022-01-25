//
//  ToolBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import UIKit

class ToolBar: UIView {
    init(point: CGPoint) {
        super.init(frame: CGRect(x: point.x, y: point.y, width: 300, height: 50))
        
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
