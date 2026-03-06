//
//  Untitled.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import Foundation


@Observable
final class ParenthesesViewModel {
    var isValid: Bool = false
    var stackItems:[Character] = []
    func validateAndVisualize(_ input: String) {
        var stack = Stack<Character>()
        stackItems = []
        
        for char in input {
            if ParenthesesValidator.opening.contains(char) {
                stack.push(char)
            }
            else if let expectedOpen = ParenthesesValidator.matching[char] {
                if stack.peek == expectedOpen {
                    _ = stack.pop()
                } else {
                    isValid = false
                    stackItems = stack.allItems
                    return
                }
            }
            stackItems = stack.allItems // snapshot after each char
        }
       
        isValid = stack.isEmpty
    }
}
