//
//  StackModel.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import Foundation

struct Stack<T> {
    private var items: [T] = []
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var count: Int {
        items.count
    }
    
    var peek: T? { items.last }
     
    // read-only snapshot of all items
    var allItems: [T] { items }


    mutating func push(_ element: T) {
        items.append(element)
    }
    
    
    mutating func pop() -> T? {
        items.popLast()
    }

}
