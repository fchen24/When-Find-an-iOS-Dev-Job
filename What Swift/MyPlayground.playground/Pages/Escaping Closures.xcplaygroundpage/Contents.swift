//: [Previous](@previous)     [Contents](Table%20of%20Contents)
//: ****
//: A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
// Escaping Closures
import Foundation

var completionHandlers: [() -> Void] = []

func someFunctionsWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionsWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionsWithEscapingClosure {
            self.x = 100
        }
        someFunctionsWithNonescapingClosure {
            x = 200
        }
    }
}

let instance = SomeClass()
print(instance.x)
// Prints "10"
instance.doSomething()
print(instance.x)
// Prints "200"
completionHandlers.first?()
print(instance.x)
// Prints "100"


class SomeOtherClass {
    var x = 10
    func doSomething() {
        someFunctionsWithEscapingClosure { [self] in
            x = 100
        }
        someFunctionsWithNonescapingClosure {
            x = 200
        }
    }
}

let instance2 = SomeClass()
print(instance2.x)
// Prints "10"
instance2.doSomething()
print(instance2.x)
// Prints "200"
completionHandlers.last?()
print(instance2.x)
// Prints "100"
//: ****
//: [Next](@next)
