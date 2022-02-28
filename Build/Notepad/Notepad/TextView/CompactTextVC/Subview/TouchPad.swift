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
    private var touchPadSize: CGFloat!
    private var width: CGFloat!
    private var height: CGFloat!

    private var tracking = false
    private var data = TouchPadData()
    private var trackingView: UIView!

    var panGesture: UIPanGestureRecognizer!
    var velocityLoop: CADisplayLink!
    
    var handleTouchStarted: (() -> Void)?
    var handler: ((TouchPadData) -> Void)?
    var handleTouchEnded: (() -> Void)?

    var originLocation: CGPoint?

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)

        super.init(frame: CGRect(x: x,
                                 y: y,
                                 width: width,
                                 height: height))

        clipsToBounds = true

        trackingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragTouchPad))

        trackingView.isUserInteractionEnabled = true
        trackingView.addGestureRecognizer(panGesture)

        addSubview(trackingView)

        velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dragTouchPad(_ sender: UIPanGestureRecognizer) {
        tracking = true
        let touchLocation = sender.location(in: self)

        if panGesture.state == .began {
            handleTouchStarted?()
            originLocation = CGPoint()
            originLocation!.x = touchLocation.x
            originLocation!.y = touchLocation.y
        }

        guard let originLocation = originLocation else { return }

        let dataCenter = CGPoint(x: touchLocation.x - originLocation.x, y: touchLocation.y - originLocation.y)

        data = TouchPadData(velocity: dataCenter, angular: -atan2(dataCenter.x, dataCenter.y))

        if panGesture.state == .ended {
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
