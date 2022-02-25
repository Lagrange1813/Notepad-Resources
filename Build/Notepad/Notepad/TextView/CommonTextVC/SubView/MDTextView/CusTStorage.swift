//
//  CustomTextStorage.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/25.
//

import UIKit

class CustomTextStorage: NSTextStorage {
    public var highlight: Highlight? {
        didSet {}
    }

    let testRegex = "^(\\#{3}(.*))$"
    

//    var backingStore = NSTextStorage()
//
//    override public var string: String {
//        return backingStore.string
//    }

    override public init() {
        super.init()
    }

    override public init(attributedString: NSAttributedString) {
        super.init(attributedString: attributedString)
//        backingStore.setAttributedString(attributedString)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func processEditing() {
        let backingString = string
        if let nsRange = backingString.range(from: NSMakeRange(NSMaxRange(editedRange), 0)) {
            let indexRange = backingString.lineRange(for: nsRange)
            let extendedRange: NSRange = NSUnionRange(editedRange, backingString.nsRange(from: indexRange))
            applyStyles(extendedRange)
        }
        super.processEditing()
    }

    func applyStyles(_ range: NSRange) {
        let style = Style(regex: testRegex.toRegex(), attributes: [.foregroundColor: UIColor.gray])
//        var styles = [style]

        style.regex.enumerateMatches(in: string, options: .withoutAnchoringBounds, range: range, using: { match, flags, stop in
            guard let match = match else { return }
            addAttributes(style.attributes, range: match.range(at: 0))
        })
    }
}
