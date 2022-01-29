//
//  CustomTextView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/28.
//

import UIKit

class CustomTextView: UITextView {
    var identifier: String!
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)

        originalRect.size.height = font!.lineHeight + 2
        originalRect.size.width = 2

        return originalRect
    }

}
