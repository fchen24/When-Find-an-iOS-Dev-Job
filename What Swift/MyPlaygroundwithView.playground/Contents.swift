//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


class MyViewController : UIViewController {
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .link

        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        label.text = "Hello World!"
        label.textColor = .black
        label.backgroundColor = .white
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
