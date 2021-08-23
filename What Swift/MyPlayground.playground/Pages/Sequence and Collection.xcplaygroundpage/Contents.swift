//: [Previous](@previous)     [Contents](Table%20of%20Contents)
//: ****
import Foundation


let possibleNumbers = ["1", "2", "three", "///4///", "5"]

// MARK: - MAP
let mapped = possibleNumbers.map { str in Int(str) }
print(mapped)
// [Optional(1), Optional(2), nil, nil, Optional(5)]

// MARK: - FlatMap (unfortunately is deprecated)
//let flatMapped = possibleNumbers.flatMap { str in Int(str) }
//print(flatMapped)
// [1, 2, 5]

// MARK: - CompactMap (use this rather than flatMap)
let compactMapped = possibleNumbers.compactMap { str in Int(str) }
print(compactMapped)
// [1, 2, 5]
//: ****
//: [Next](@next)
