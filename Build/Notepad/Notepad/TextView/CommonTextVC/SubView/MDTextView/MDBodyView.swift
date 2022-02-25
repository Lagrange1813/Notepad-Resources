//
//  MDBodyView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import UIKit

class MDBodyView: CustomTextView {
    var storage: CustomTextStorage = CustomTextStorage()
//    var storage = NSTextStorage()
    
    init() {
        let layoutManager = NSLayoutManager()
        let containerSize = CGSize(width: 400, height: CGFloat.greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true

        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        super.init(frame: CGRect(), textContainer: container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
