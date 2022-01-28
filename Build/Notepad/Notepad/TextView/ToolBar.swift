//
//  ToolBar.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import SnapKit
import UIKit

class ToolBar: UIView {

    var lastLocation: CGPoint!
    let btnLength = 20.0
    let btnSpacing = 10.0
    var width: CGFloat = {
        switch ScreenSize.width {
        case 0...330:
            return 7 * 40.0 + 4
        case 330...370:
            return 8 * 40.0 + 4
        case 370...410:
            return 9 * 40.0 + 4
        case 410...450:
            return 10 * 40.0 + 4
        default:
            return 9 * 40.0 + 4
        }
    }()
    var height = 40.0

    let fixedBarItem = ("command", "arrowshape.turn.up.backward", "doc.on.clipboard", "arrowtriangle.down", "rectangle.on.rectangle")

    var scrollBarItem = ["quotes": ("“”", true, "“”"), "sqr-brackets": ("「」", true, "「」"), "brackets": ("（）", true, "（）"), ]

    var tracking = false

    var velocityLoop: CADisplayLink!
    var toolBG: ToolBG!

    var commandBtn: CustomBtn!
    var returnBtn: CustomBtn!
    var pasteBtn: CustomBtn!
    var downBtn: CustomBtn!

    init() {
        super.init(frame: CGRect())
//        lastLocation = self.center
//        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.detectPan(_:)))
//        self.gestureRecognizers = [panRecognizer]

        self.backgroundColor = ColorCollection.lightToolBG
        self.alpha = 0.9
        self.tintColor = .black
        layer.cornerRadius = height / 2

        let rightBG: UIView = {
            let view = UIView(frame: CGRect(x: height, y: 0, width: width - height, height: height))
            view.backgroundColor = ColorCollection.lightToolBG
            view.layer.cornerRadius = height / 2
            return view
        }()
        addSubview(rightBG)

        self.toolBG = { () -> ToolBG in
            let toolBG = ToolBG(frame: CGRect(x: height * 3 + 2, y: 0, width: width - height * 4 - 2.0, height: height))
            toolBG.alpha = 1
            toolBG.contentSize = CGSize(width: 10 * height, height: height)
            toolBG.canCancelContentTouches = true
            toolBG.delaysContentTouches = false
            toolBG.showsHorizontalScrollIndicator = false
//            toolBG.isPagingEnabled = true
            return toolBG
        }()
        addSubview(toolBG)

        configureFixedButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translation: CGPoint? = recognizer.translation(in: superview)
        if let translation = translation {
            center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        }
    }

    @objc func watching() {
        if tracking {
            if frame.origin.x < 0 {
                frame.origin.x = 0
            }
            if frame.origin.x + width > ScreenSize.width {
                frame.origin.x = ScreenSize.width - width
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>?, with event: UIEvent!) {
        lastLocation = center
        print("start!")

        tracking = true
//        velocityLoop = CADisplayLink(target: self, selector: #selector(watching))
//        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moving!")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended!")
        tracking = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancelled!")
//        tracking = false
    }

    func configureFixedButton() {
        commandBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(systemName: fixedBarItem.0), for: .normal)
//
            return button
        }()
        addSubview(commandBtn)

        returnBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 1 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(systemName: fixedBarItem.1), for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        }()
        addSubview(returnBtn)

        pasteBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(systemName: fixedBarItem.2), for: .normal)
            return button
        }()
        addSubview(pasteBtn)

        downBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: width - height + height / 2 - btnLength / 2 - 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(systemName: fixedBarItem.3), for: .normal)
            return button
        }()
        addSubview(downBtn)

        for x in 0...9 {
            let testBtn = UIView()

            testBtn.backgroundColor = .blue

            toolBG.addSubview(testBtn)
            testBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(x))
                make.size.width.height.equalTo(20)
            }
        }
    }

}
