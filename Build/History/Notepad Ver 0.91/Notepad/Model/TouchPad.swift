//
//  TouchPad.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/29.
//

import UIKit

public struct TouchPadData: CustomStringConvertible {
    var velocity = CGPoint.zero,
        angular = CGFloat(0)
    
    public var description: String {
        return "TouchPadData(velocity: \(velocity), angular: \(angular))"
    }
}

class TouchPad: UIView {
    private let touchPadSize: CGFloat!
    private let substractSize: CGFloat!
    private var innerRadius: CGFloat = 0.0
    var tracking = false
    private var data = TouchPadData()

    let touchPadView = UIView()

    var panGesture: UIPanGestureRecognizer!
    var velocityLoop: CADisplayLink!
    var handler: ((TouchPadData) -> Void)?
    var handleTouchEnded: (() -> ())?

    init(x: Double, y: Double, size: Int) {
        substractSize = CGFloat(size)
        touchPadSize = CGFloat(size / 2)

        super.init(frame: CGRect(x: x,
                                 y: y,
                                 width: substractSize,
                                 height: substractSize))

        backgroundColor = .gray
        layer.cornerRadius = CGFloat(substractSize / 2)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragTouchPad))

        touchPadView.isUserInteractionEnabled = true
        touchPadView.addGestureRecognizer(panGesture)
        touchPadView.backgroundColor = .white
        touchPadView.layer.cornerRadius = CGFloat(touchPadSize / 2)
        touchPadView.frame = CGRect(x: touchPadSize / 2.0, y: touchPadSize / 2.0, width: touchPadSize, height: touchPadSize)
        addSubview(touchPadView)

        innerRadius = (substractSize - touchPadSize) * 0.5

        velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        touchPadView.frame = CGRect(x: touchPadSize / 2.0, y: touchPadSize / 2.0, width: touchPadSize, height: touchPadSize)
    }

    func lineLength(from pt1: CGPoint, to pt2: CGPoint) -> CGFloat {
        return hypot(pt2.x - pt1.x, pt2.y - pt1.y)
    }

    func pointOnLine(from startPt: CGPoint, to endPt: CGPoint, distance: CGFloat) -> CGPoint {
        let totalDistance = lineLength(from: startPt, to: endPt)
        let totalDelta = CGPoint(x: endPt.x - startPt.x, y: endPt.y - startPt.y)
        let pct = distance / totalDistance
        let delta = CGPoint(x: totalDelta.x * pct, y: totalDelta.y * pct)
        return CGPoint(x: startPt.x + delta.x, y: startPt.y + delta.y)
    }

    @objc func dragTouchPad(_ sender: UIPanGestureRecognizer) {
        tracking = true
        let touchLocation = sender.location(in: self)

        let outerCircleViewCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)

        var newCenter = touchLocation

        let distance = lineLength(from: touchLocation, to: outerCircleViewCenter)

        if distance > innerRadius {
            newCenter = pointOnLine(from: outerCircleViewCenter, to: touchLocation, distance: innerRadius)
        }

        touchPadView.center = newCenter

        let dataCenter = CGPoint(x: newCenter.x - touchPadSize, y: newCenter.y - touchPadSize)
        data = TouchPadData(velocity: dataCenter, angular: -atan2(dataCenter.x, dataCenter.y))

        if panGesture.state == .ended {
            reset()
            tracking = false
            handleTouchEnded?()
        }
    }

    @objc func listen() {
        if tracking {
            handler?(data)
        }
    }
}
