//
//  ViewController.swift
//  AutoResizingMask-Test
//
//  Created by 张维熙 on 2022/6/8.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let backgroundView = BackgroundView()
        backgroundView.backgroundColor = .blue
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }


}

class BackgroundView: UIView {
    let subview = UIView()
    let testFrame = CGRect(x: 0, y: 0, width: 0, height: 100)
    
    init() {
        super.init(frame: .zero)
        
        subview.backgroundColor = .systemBlue
        subview.frame = testFrame
        subview.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        addSubview(subview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
