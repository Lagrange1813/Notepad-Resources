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
    
    var width: CGFloat!
    var height = 40.0

    let fixedBarItem = ("command",
                        "arrowshape.turn.up.backward",
                        "doc.on.clipboard",
                        "keyboard.chevron.compact.down")

    var shortcutBarItem = ["“”",
                           "「」",
                           "（）",
                           "platter.filled.top.and.arrow.up.iphone",
                           "platter.filled.bottom.and.arrow.down.iphone",
                           "arrowshape.turn.up.right"]

//    var scrollBarItem = ["quotes": ("“”", true, "“”"),
//                         "sqr-brackets": ("「」", true, "「」"),
//                         "brackets": ("（）", true, "（）")]

    var tracking = false

    var velocityLoop: CADisplayLink!
    var toolBG: ToolBG!

    var commandBtn: CustomBtn!
    
    var touchPad: TouchPad!
    
    var undoBtn: CustomBtn!
    var pasteBtn: CustomBtn!
    var downBtn: CustomBtn!

    var quotesBtn: CustomBtn!
    var sqrBracketsBtn: CustomBtn!
    var bracketsBtn: CustomBtn!

    var jumpToTop: CustomBtn!
    var jumpToBottom: CustomBtn!
    
    var redoBtn: CustomBtn!

    init() {
        super.init(frame: CGRect())
        
        width = ToolBar.width()
        
//        lastLocation = self.center
//        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.detectPan(_:)))
//        self.gestureRecognizers = [panRecognizer]

        self.backgroundColor = ColorCollection.lightToolBG
        self.alpha = 0.95
        self.tintColor = .black
//        self.clipsToBounds = true
        layer.cornerRadius = height / 2
        
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1.5

//        let rightBG: UIView = {
//            let view = UIView(frame: CGRect(x: height, y: 0, width: width - height, height: height))
//            view.backgroundColor = ColorCollection.lightToolBG
//            view.layer.cornerRadius = height / 2
//            return view
//        }()
//        addSubview(rightBG)

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
    
    class func width() -> CGFloat {
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
    }

//    override func touchesBegan(_ touches: Set<UITouch>?, with event: UIEvent!) {
//        lastLocation = center
//        print("start!")
//
//        tracking = true
////        velocityLoop = CADisplayLink(target: self, selector: #selector(watching))
////        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("moving!")
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("ended!")
//        tracking = false
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("cancelled!")
////        tracking = false
//    }

    func configureFixedButton() {
        commandBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(named: fixedBarItem.0), for: .normal)
            addSubview(button)
            
            return button
        }()

        undoBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 1 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(named: fixedBarItem.1), for: .normal)
            button.setTitleColor(.black, for: .normal)
            addSubview(button)
            
            return button
        }()

        pasteBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: height / 2 - btnLength / 2 + height * 2 + 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(named: fixedBarItem.2), for: .normal)
            addSubview(button)
            
            return button
        }()

        downBtn = { () -> CustomBtn in
            let button = CustomBtn(frame: CGRect(x: width - height + height / 2 - btnLength / 2 - 2, y: height / 2 - btnLength / 2, width: btnLength, height: btnLength))
            button.setImage(UIImage(named: fixedBarItem.3), for: .normal)
            addSubview(button)
            
            return button
        }()

        quotesBtn = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setTitle(shortcutBarItem[0], for: .normal)
            shortcutBtn.setTitleColor(.black, for: .normal)
            shortcutBtn.setTitleColor(.systemGray, for: .highlighted)
            shortcutBtn.titleLabel!.font = UIFont(name: "LXGW WenKai", size: 15)
            shortcutBtn.argument = shortcutBarItem[0]

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(0))
                make.size.width.height.equalTo(30)
            }

            return shortcutBtn
        }()

        sqrBracketsBtn = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setTitle(shortcutBarItem[1], for: .normal)
            shortcutBtn.setTitleColor(.black, for: .normal)
            shortcutBtn.setTitleColor(.systemGray, for: .highlighted)
            shortcutBtn.titleLabel!.font = UIFont(name: "LXGW WenKai", size: 15)
            shortcutBtn.argument = shortcutBarItem[1]

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(1))
                make.size.width.height.equalTo(30)
            }

            return shortcutBtn
        }()

        bracketsBtn = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setTitle(shortcutBarItem[2], for: .normal)
            shortcutBtn.setTitleColor(.black, for: .normal)
            shortcutBtn.setTitleColor(.systemGray, for: .highlighted)
            shortcutBtn.titleLabel!.font = UIFont(name: "LXGW WenKai", size: 15)
            shortcutBtn.argument = shortcutBarItem[2]

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(2))
                make.size.width.height.equalTo(30)
            }

            return shortcutBtn
        }()

        jumpToTop = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setImage(UIImage(named: shortcutBarItem[3]), for: .normal)
//            shortcutBtn.argument = "top"

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(3))
                make.size.width.height.equalTo(40)
            }

            return shortcutBtn
        }()

        jumpToBottom = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setImage(UIImage(named: shortcutBarItem[4]), for: .normal)
//            shortcutBtn.argument = "bottom"

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(4))
                make.size.width.height.equalTo(40)
            }

            return shortcutBtn
        }()

        redoBtn = { () -> CustomBtn in
            let shortcutBtn = CustomBtn()
            shortcutBtn.setImage(UIImage(named: shortcutBarItem[5]), for: .normal)

            toolBG.addSubview(shortcutBtn)
            shortcutBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(height / 2 + 40.0 * Double(5))
                make.size.width.height.equalTo(40)
            }

            return shortcutBtn
        }()
        
        for x in 6...9 {
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
    
    func configureTouchPad(_ commandHeight: CGFloat) {
        let touchPadWidth: CGFloat = 200
        let touchPadHeight: CGFloat = 200
        
        touchPad = TouchPad(x: width/2 - CGFloat(touchPadWidth/2),
                            y: height + commandHeight/2 - touchPadHeight/2 - 5,
                                width: 200,
                                height: 200)
        touchPad.backgroundColor = .white
        touchPad.layer.cornerRadius = touchPadWidth/2
        addSubview(touchPad)
        
        let icon = UIImageView(image: UIImage(systemName: "ipad.landscape"))
        touchPad.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.center.equalToSuperview()
        }
        
        touchPad.isHidden = true
    }
}
