//
//  StringReversal.swift
//  TheStackLab
//
//  Created by D F on 3/1/26.
//

import Foundation

struct StringReversal {
    static func reverseWithStack(_ input: String) -> String {
        var stack = Stack<Character>()
        var result = ""
        
        for char in input {
            stack.push(char)
        }
        
        while !stack.isEmpty {
            if let char = stack.pop() {
                result.append(char)
            }
        }
        return result
    }
}


/*
 abcd
 stack = [a, b, c, d]
     -> [d]
     -> [d, c]
     -> [d, c, b]
     -> [d,c,b,a]
    -> "d, c, b, a"
 */
