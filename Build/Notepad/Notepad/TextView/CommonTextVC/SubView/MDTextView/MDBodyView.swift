//
//  MDBodyView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import UIKit

class MDBodyView: CustomTextView {
    override var textStorage: NSTextStorage {
        return CustomTextStorage()
    }
}
