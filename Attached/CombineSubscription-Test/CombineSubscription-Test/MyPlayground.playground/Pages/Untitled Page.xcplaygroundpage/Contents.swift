import Combine
import Foundation

extension UserDefaults {
    @objc var testID: String {
        get { string(forKey: "Test") ?? "" }
        set { set(newValue, forKey: "Test") }
    }
}

var cancelBag = Set<AnyCancellable>()

let user = UserDefaults.standard

user.publisher(for: \.testID)
    .sink {
        print($0)
    }
    .store(in: &cancelBag)

user.testID = "Hello"
user.testID = "AAA"

