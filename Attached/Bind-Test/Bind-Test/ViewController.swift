//
//  ViewController.swift
//  Bind-Test
//
//  Created by 张维熙 on 2022/6/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        
        let slider = UISlider(frame: CGRect(x: 50, y: 200, width: 300, height: 30))
        view.addSubview(slider)
        
        let test = BindTest()
        
        test.sign
            .bind(to: slider.rx.currentValue)
            .disposed(by: bag)
        
        slider.rx.value
            .subscribe(onNext: {
                test.size = CGFloat($0)
                print($0)
            })
            .disposed(by: bag)
        
//        let aaa = UILabel()
//
//        slider.rx.value
//            .map { String($0)}
//            .bind(to: aaa.rx.text)
        
        
    }

    
}

class BindTest {
    
    var sign: BehaviorRelay<CGFloat> = BehaviorRelay(value: 0)
    
    var size: CGFloat = 0 {
        didSet {
            sign.accept(size)
        }
    }
}

//class TestSlider: UISlider {
//    var number: Binder<CGFloat> = Binder(self, binding: { _, value in
//        setValue(Float(value), animated: false)
//    })
//
//}

extension Reactive where Base: UISlider {
//    public func titleForSegment(at index: Int) -> Binder<String?> {
//        return Binder(self.base) { segmentedControl, title -> Void in
//            segmentedControl.setTitle(title, forSegmentAt: index)
//        }
//    }
    public func currentValue() -> Binder<CGFloat> {
        return Binder(self.base) {
            $0.setValue($1, animated: false)
        }
    }
    
}
