last edited: 2021.08.15 @fei.chen

------

In Swift:

[TOC]

# [Automatic Reference Counting (ARC)](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)

## 1). In most cases, memory management “just works” in Swift, and don’t need to think about memory management yourself. 

- ARC automatically frees up the memory used by **<u>(class instances)</u>** when those instances are no longer needed.

  e.g.

```swift
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed")
// Prints "John Appleseed is being initialized"

reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil

reference3 = nil
// Prints "John Appleseed is being deinitialized"
```

> If ARC were to deallocate an instance that was still in use, it would no longer be possible to access that instance’s properties, or call that instance’s methods. Indeed, if you tried to access the instance, your app would most likely crash.
>
> To make sure that instances don’t disappear while they’re still needed, ARC tracks how many **properties**, **constants**, and **variables** are currently referring to each class instance. <u>ARC will not deallocate an instance as long as at least one active **strong** reference to that instance still exists.</u> The reference is called a “strong” reference because it keeps a firm hold on that instance, and <u>doesn’t allow it to be deallocated for as long as that strong reference remains</u>.

## 2). In a few cases, ARC requires more information about the relationships between parts of your code in order to manage memory for you - (reference cycles problem)

1. ##### **Strong Reference Cycles Between Class Instances**

   Possible an instance of a class *never* gets to a point where it has zero strong references. If two class instances hold a strong reference to each other, such that each instance keeps the other alive. This is known as a *strong reference cycle*.

   ```swift
   class Person {
       let name: String
       init(name: String) { self.name = name }
       var apartment: Apartment?
       deinit { print("\(name) is being deinitialized") }
   }
   
   class Apartment {
       let unit: String
       init(unit: String) { self.unit = unit }
       var tenant: Person?
       deinit { print("Apartment \(unit) is being deinitialized") }
   }
   
   var john: Person?
   var unit4A: Apartment?
   
   john = Person(name: "John Appleseed")
   unit4A = Apartment(unit: "4A")
   
   john!.apartment = unit4A
   unit4A!.tenant = john
   
   john = nil
   unit4A = nil
   ```

   ![../_images/referenceCycle01_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle01_2x.png)

   ![../_images/referenceCycle02_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle02_2x.png)

   ![../_images/referenceCycle03_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle03_2x.png)

   - ###### *weak references*

     Use a weak reference when the other instance has a shorter lifetime—that is, when the other instance can be deallocated first.

     A *weak reference* is a reference that doesn’t keep a strong hold on the instance it refers to, and so doesn’t stop ARC from disposing of the referenced instance.

     ARC automatically sets a weak reference to `nil` when the instance that it refers to is deallocated. 

     ```swift
     class Person {
         let name: String
         init(name: String) { self.name = name }
         var apartment: Apartment?
         deinit { print("\(name) is being deinitialized") }
     }
     
     class Apartment {
         let unit: String
         init(unit: String) { self.unit = unit }
         weak var tenant: Person?
         deinit { print("Apartment \(unit) is being deinitialized") }
       
     var john: Person?
     var unit4A: Apartment?
     
     john = Person(name: "John Appleseed")
     unit4A = Apartment(unit: "4A")
     
     john!.apartment = unit4A
     unit4A!.tenant = john
     
     john = nil
     // Prints "John Appleseed is being deinitialized"
     ```

     ![../_images/weakReference01_2x.png](https://docs.swift.org/swift-book/_images/weakReference01_2x.png)

     ![../_images/weakReference02_2x.png](https://docs.swift.org/swift-book/_images/weakReference02_2x.png)

   - ###### *unowned references*

     Use an unowned reference when the other instance has the same lifetime or a longer lifetime.

     An unowned reference is expected to always have a value. As a result, marking a value as unowned doesn’t make it optional, and ARC never sets an unowned reference’s value to `nil`.

     ```swift
     class Customer {
         let name: String
         var card: CreditCard?
         init(name: String) {
             self.name = name
         }
         deinit { print("\(name) is being deinitialized") }
     }
     
     class CreditCard {
         let number: UInt64
         unowned let customer: Customer
         init(number: UInt64, customer: Customer) {
             self.number = number
             self.customer = customer
         }
         deinit { print("Card #\(number) is being deinitialized") }
     }
     
     var john: Customer?
     
     john = Customer(name: "John Appleseed")
     john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
     
     john = nil
     // Prints "John Appleseed is being deinitialized"
     // Prints "Card #1234567890123456 is being deinitialized"
     ```

     ![../_images/unownedReference01_2x.png](https://docs.swift.org/swift-book/_images/unownedReference01_2x.png)

     ![../_images/unownedReference02_2x.png](https://docs.swift.org/swift-book/_images/unownedReference02_2x.png)

   - ###### *unowned optional references*

     You can mark an optional reference to a class as unowned. In terms of the ARC ownership model, an unowned optional reference and a weak reference can both be used in the same contexts. The difference is that when you use an unowned optional reference, you’re responsible for making sure it always refers to a valid object or is set to `nil`.

     ```swift
     class Department {
         var name: String
         var courses: [Course]
         init(name: String) {
             self.name = name
             self.courses = []
         }
     }
     
     class Course {
         var name: String
         unowned var department: Department
         unowned var nextCourse: Course?
         init(name: String, in department: Department) {
             self.name = name
             self.department = department
             self.nextCourse = nil
         }
     }
     
     let department = Department(name: "Horticulture")
     
     let intro = Course(name: "Survey of Plants", in: department)
     let intermediate = Course(name: "Growing Common Herbs", in: department)
     let advanced = Course(name: "Caring for Tropical Plants", in: department)
     
     intro.nextCourse = intermediate
     intermediate.nextCourse = advanced
     department.courses = [intro, intermediate, advanced]
     ```

     ![../_images/unownedOptionalReference_2x.png](https://docs.swift.org/swift-book/_images/unownedOptionalReference_2x.png)

   - ###### *Unowned References and Implicitly Unwrapped Optional Properties*

     todo

     ```swift
     class Country {
         let name: String
         var capitalCity: City!
         init(name: String, capitalName: String) {
             self.name = name
             self.capitalCity = City(name: capitalName, country: self)
         }
     }
     
     class City {
         let name: String
         unowned let country: Country
         init(name: String, country: Country) {
             self.name = name
             self.country = country
         }
     }
     
     var country = Country(name: "Canada", capitalName: "Ottawa")
     print("\(country.name)'s capital city is called \(country.capitalCity.name)")
     // Prints "Canada's capital city is called Ottawa"
     ```

     

2. ##### **Strong Reference Cycles for Closures**

   A strong reference cycle can also occur if you assign a closure to a property of a class instance, and the body of that closure captures the instance. This capture might occur because the closure’s body accesses a property of the instance, such as `self.someProperty`, or because the closure calls a method on the instance, such as `self.someMethod()`. In either case, these accesses cause the closure to “capture” `self`, creating a strong reference cycle.

   *closure capture list*

   ```swift
   class HTMLElement {
   
       let name: String
       let text: String?
   
       lazy var asHTML: () -> String = {
           if let text = self.text {
               return "<\(self.name)>\(text)</\(self.name)>"
           } else {
               return "<\(self.name) />"
           }
       }
   
       init(name: String, text: String? = nil) {
           self.name = name
           self.text = text
       }
   
       deinit {
           print("\(name) is being deinitialized")
       }
   
   }
   
   let heading = HTMLElement(name: "h1")
   let defaultText = "some default text"
   heading.asHTML = {
       return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
   }
   print(heading.asHTML())
   // Prints "<h1>some default text</h1>"
   
   var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
   print(paragraph!.asHTML())
   // Prints "<p>hello, world</p>"
   
   paragraph = nil
   ```

   ![../_images/closureReferenceCycle01_2x.png](https://docs.swift.org/swift-book/_images/closureReferenceCycle01_2x.png)

   

   - ###### Defining a Capture List

     ```swift
     lazy var someClosure = {
         [unowned self, weak delegate = self.delegate]
         (index: Int, stringToProcess: String) -> String in
         // closure body goes here
     }
     ```

     ```swift
     lazy var someClosure = {
         [unowned self, weak delegate = self.delegate] in
         // closure body goes here
     }
     ```

     ```swift
     class HTMLElement {
     
         let name: String
         let text: String?
     
         lazy var asHTML: () -> String = {
             [unowned self] in
             if let text = self.text {
                 return "<\(self.name)>\(text)</\(self.name)>"
             } else {
                 return "<\(self.name) />"
             }
         }
     
         init(name: String, text: String? = nil) {
             self.name = name
             self.text = text
         }
     
         deinit {
             print("\(name) is being deinitialized")
         }
     
     }
     
     var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
     print(paragraph!.asHTML())
     // Prints "<p>hello, world</p>"
     
     paragraph = nil
     // Prints "p is being deinitialized"
     ```

     ![../_images/closureReferenceCycle02_2x.png](https://docs.swift.org/swift-book/_images/closureReferenceCycle02_2x.png)

