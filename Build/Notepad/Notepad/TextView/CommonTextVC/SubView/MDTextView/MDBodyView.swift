//
//  MDBodyView.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import UIKit

class MDBodyView: CustomTextView {
    var storage: CustomTextStorage = CustomTextStorage()

//    convenience public init() {
//        self.init(frame: CGRect(), textContainer: nil)
//    }
//
//    override init(frame: CGRect,textContainer: NSTextContainer?) {
//        let layoutManager = NSLayoutManager()
//        let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
//        let container = NSTextContainer(size: containerSize)
//        container.widthTracksTextView = true
//
//        layoutManager.addTextContainer(container)
//        storage.addLayoutManager(layoutManager)
//        super.init(frame: frame, textContainer: container)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
