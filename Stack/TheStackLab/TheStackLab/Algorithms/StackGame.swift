//
//  StackGame.swift
//  TheStackLab
//
//  Created by D F on 3/2/26.
//

import Foundation

struct StackGame {
    private var stack = Stack<Int>()
    
    var currentStack: [Int] {
        stack.allItems
    }
    
    var total: Int {
        stack.allItems.reduce(0, +)
    }
    
    var top: Int? {
        stack.peek
    }
    
    mutating func applyOp(_ action: StackGameAction) {
        switch action {
        case .number(let value):
            stack.push(value)
        case .add:
            guard stack.count >= 2 else {return}
            let last = stack.pop()!
            let second = stack.pop()!
            stack.push(last + second)
        case .cancel:
            guard !stack.isEmpty else {return}
            _ = stack.pop()
        case .double:
            guard let last = stack.peek else {return}
            stack.push(last * 2)
        }
        
    }
    
    
}
