//: [Previous](@previous)     [Contents](Table%20of%20Contents)
//: ****
// A UIKit based Playground for presenting user interface
import Foundation
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .link
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
//: ****
//: [Next](@next)
