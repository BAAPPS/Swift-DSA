//
//  GreaterTemperatureDay.swift
//  TheMonotonicLab
//
//  Created by D F on 3/12/26.
//

import Foundation


struct TemperatureDay {
    static func findGreaterTemperatureDay(_ input: [Int]) -> [TemperatureResult] {
        var stack = Stack<Int>()
        var result = Array(
            repeating: TemperatureResult(days: -1,  previousValue: -1, nextValue: -1),
            count: input.count
        )
        
        for (i, current) in input.enumerated() {
            while let lastIndex = stack.peek, input[lastIndex] < current {
                if let resolvedIndex = stack.pop() {
                    result[resolvedIndex] = TemperatureResult(
                        days: i - resolvedIndex,
                        previousValue: input[lastIndex],
                        nextValue: current
                    )
                }
            }
            
            stack.push(i)
        }
        return result
    }
    
    static func findSmallerTemperatureDay(_ input: [Int]) -> [TemperatureResult] {
        var stack = Stack<Int>()
        var result = Array(
            repeating: TemperatureResult(days: -1, previousValue: -1, nextValue: -1),
            count: input.count
        )

        for (i, current) in input.enumerated() {
            while let lastIndex = stack.peek, input[lastIndex] > current {
                if let resolvedIndex = stack.pop() {
                    result[resolvedIndex] = TemperatureResult(
                        days: i - resolvedIndex,
                        previousValue: input[lastIndex],
                        nextValue: current
                    )
                }
            }
            stack.push(i)
        }

        return result
    }
    
    
    
}
