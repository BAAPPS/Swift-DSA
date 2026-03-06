//
//  ParenthesesModel.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import Foundation

struct ParenthesesValidator {
    
    // MARK: - Rules
    static let opening: Set<Character> = ["(", "{", "["]
    static let matching: [Character: Character] = ["}": "{", "]": "[", ")": "("]
    
    
    // MARK: - Validation Logic
    
   static func isValid(_ input: String) -> Bool {
       var stack = Stack<Character>()
       for char in input {
           if opening.contains(char) {
               stack.push(char)
           } else if let expectedOpen = matching[char] {
               guard let last = stack.pop(), last == expectedOpen else {
                   return false
               }
           }
       }
       return stack.isEmpty
   }
    
}
