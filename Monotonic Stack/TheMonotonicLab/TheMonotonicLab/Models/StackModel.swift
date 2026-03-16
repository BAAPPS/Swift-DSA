//
//  StackModel.swift
//  TheMonotonicLab
//
//  Created by D F on 3/12/26.
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
    
    mutating func push(_ element: T) {
        items.append(element)
    }
    
    mutating func pop() -> T? {
        items.popLast()
    }
    
}
