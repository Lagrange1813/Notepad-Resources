import Combine
import Foundation

extension UserDefaults {
    @objc var somePropery: String {
        get { string(forKey: "somePropey") ?? "" }
        set { set(newValue, forKey: "somePropey") }
    }
}

var cancellable = Set<AnyCancellable>()

let defaults = UserDefaults.standard

defaults
    .publisher(for: \.somePropery)
    .sink { print("Sink: \($0)") }
    .store(in: &cancellable)


defaults.somePropery = "TT"
defaults.somePropery = "FF"

