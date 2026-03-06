//
//  StringReversalVM.swift
//  TheStackLab
//
//  Created by D F on 3/1/26.
//

import Foundation

@Observable
final class StringReversalViewModel {
    var stackItems:[Character] = []
    var reversedString =  ""
    var steps: [StackAction] = []
    var currentStepIndex: Int = 0
    var reversedInstantly = ""
    
    func prepareSteps(for input: String) {
        steps = []
        stackItems = []
        reversedString = ""
        currentStepIndex = 0
        
        var stack = Stack<Character>()
        
        for char in input {
            stack.push(char)
            steps.append(.push(char))
        }
        
        while let char = stack.pop() {
            steps.append(.pop(char))
        }
        
    }
    
    func performNextStep() {
        guard currentStepIndex < steps.count else { return }
        let action = steps[currentStepIndex]
        
        switch action {
        case .push(let char):
            stackItems.append(char)
        case .pop(let char):
            if !stackItems.isEmpty {
                stackItems.removeLast()
            }
            reversedString.append(char)
        }
        
        currentStepIndex += 1
        
    }
    
    func reset() {
        stackItems = []
        reversedString = ""
        currentStepIndex = 0
    }
    
    
     func reverseInstantly(_ input: String) {
         reversedInstantly = StringReversal.reverseWithStack(input)
     }
}
