//
//  WordCount.swift
//  观辞
//
//  Created by 张维熙 on 2022/1/22.
//

import UIKit

class WordCount: UIView {
    var number = 0
    lazy var width: CGFloat = {
        var temp = 0.0
        switch number {
        case 0..<10: temp = 50.0
        case 10..<100: temp = 56.6666
        case 100..<1000: temp = 63.3333
        case 1000..<10000: temp = 70.0
        case 10000..<100000: temp = 76.6666
        case 100000..<1000000: temp = 83.3333
        case 1000000..<10000000: temp = 90.0
        default: temp = 50.0
        }
        return CGFloat(temp)
    }()

    var data = UILabel()

    init() {
        super.init(frame: CGRect(x: ScreenSize.width - 60.0,
                                 y: 5,
                                 width: 55,
                                 height: 20))
        data.text = "字数：\(number)"
        data.font = .systemFont(ofSize: 10)
        data.textColor = .white
        data.frame = CGRect(x: 10, y: 0, width: 50, height: 20)
        addSubview(data)
        self.backgroundColor = ColorCollection.countBackground
        layer.cornerRadius = 7
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshLabel(_ count: Int) {
        number = count
        data.text = "字数：\(number)"
        frame = CGRect(x: ScreenSize.width - width - 10.0,
                       y: 5,
                       width: width + 5,
                       height: 20)
        data.frame = CGRect(x: 10,
                            y: 0,
                            width: width,
                            height: 20)
    }
}
