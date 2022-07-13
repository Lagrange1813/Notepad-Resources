//
//  ViewController.swift
//  CombineSubscription-Test
//
//  Created by 张维熙 on 2022/7/7.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var cancelBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let user = UserDefaults.standard
        
        UserDefaults.standard.publisher(for: \.testID)
            .sink {
                print($0)
            }
            .store(in: &cancelBag)
        
        user.testID = "Hello"
        user.testID = "AAA"
//        user.set("Hello", forKey: "Test")
//        user.set("BBB", forKey: "Test")
    }


}

extension UserDefaults {
    @objc var testID: String {
        get { string(forKey: "Test") ?? "" }
        set { set(newValue, forKey: "Test") }
    }
}
