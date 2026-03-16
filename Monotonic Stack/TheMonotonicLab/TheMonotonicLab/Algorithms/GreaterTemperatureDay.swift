//
//  GreaterTemperatureDay.swift
//  TheMonotonicLab
//
//  Created by D F on 3/12/26.
//

import Foundation

struct GreaterTemperatureDay {
    static func findGreaterTemperatureDay(_ input: [Int]) -> [Int] {
        var stack = Stack<Int>()
        var result:[Int] = Array(repeating:0, count: input.count)
        
        for (i, current) in input.enumerated() {
            while let lastIndex = stack.peek, input[lastIndex] < current {
                if let resolvedIndex = stack.pop() {
                    result[resolvedIndex] = i - resolvedIndex
                }
            }
            stack.push(i)
        }
        return result
    }
}
