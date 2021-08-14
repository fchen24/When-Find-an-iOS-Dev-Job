last edited: 2021.08.15 @fei.chen

------

In swift:

# What is Map, FlatMap, Filter and Reduce?



## protocols: Sequence <- Collcetions

- Sequence: A type that provides sequential, iterated access to its elements. The most common way to iterate over the elements of a sequence is to use a `for`-`in` loop.
- Collections: A sequence whose elements can be traversed multiple times, nondestructively, and accessed by an indexed subscript.
- Collections: Array, Dictionary, ...

## [map](https://developer.apple.com/documentation/swift/collection/2908394-map)

- Returns an array containing the results of mapping the given closure over the sequence’s elements.

  ```swift
  let cast = ["Vivien", "Marlon", "Kim", "Karl"]
  let lowercaseNames = cast.map { $0.lowercased() }
  // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
  let letterCounts = cast.map { $0.count }
  // 'letterCounts' == [6, 6, 3, 4]
  ```

## [compactMap](https://developer.apple.com/documentation/swift/sequence/2950916-compactmap)

- Returns an array containing the non-`nil` results of calling the given transformation with each element of this sequence.

  ```swift
  let possibleNumbers = ["1", "2", "three", "///4///", "5"]
  
  let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
  // [1, 2, nil, nil, 5]
  
  let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
  // [1, 2, 5]
  ```

## [flatMap](https://developer.apple.com/documentation/swift/sequence/2905332-flatmap)

- Returns an array containing the concatenated results of calling the given transformation with each element of this sequence.

  ```swift
  let numbers = [1, 2, 3, 4]
  
  let mapped = numbers.map { Array(repeating: $0, count: $0) }
  // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
  
  let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
  // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
  ```

## [filter](https://developer.apple.com/documentation/swift/sequence/3018365-filter)

- Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.

  ```swift
  let cast = ["Vivien", "Marlon", "Kim", "Karl"]
  let shortNames = cast.filter { $0.count < 5 }
  print(shortNames)
  // Prints "["Kim", "Karl"]"
  ```

## reduce

- Returns the result of combining the elements of the sequence using the given closure.

  ```swift
  let numbers = [1, 2, 3, 4]
  let numberSum = numbers.reduce(0, { x, y in
      x + y
  })
  // numberSum == 10
  ```

  

