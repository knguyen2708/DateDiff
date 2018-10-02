import Foundation


protocol Container {
    associatedtype Item
    
    mutating func append(item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

class Stack<T>: Container {
    
    var items: [T] = []
    
    func append(item: T) {
        
    }
    
    var count: Int { return 0 }
    
    subscript(i: Int) -> T {
        return items.first!
    }
}
