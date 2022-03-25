import UIKit

class classa {
  var list: [()] {[test1(),test2()]}
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    run()
//  }
  
  func run() {
    for functiontype in list {
      functiontype
    }
  }
  
  func test1() {
    var varible = 100
    print(varible)
  }
  
  func test2() {
    var varible = 200
    print(varible)
  }
}

class classb: classa {
  override var list: [()] {
    [test2(), test1()]
  }
}

let test = classb()
test.run()
