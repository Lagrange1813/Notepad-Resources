import UIKit
import RxSwift
import RxCocoa

let sigleton = DataManager()

struct Test {
  var string = "Rx"
  var int = 1
}

class DataManager {
  class var shared: DataManager {
    sigleton
  }
  
  var theme = Test()
  
  var themeOb = BehaviorRelay<Test>(value: Test())
  
}

let observer1 = DataManager.shared.themeOb
  .subscribe(onNext: {
    print($0.string, $0.int)
  })

DataManager.shared.themeOb.accept(Test(string: "Haha", int: 2))

