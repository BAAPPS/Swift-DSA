//
//  StackGameOperationViewModel.swift
//  TheStackLab
//
//  Created by D F on 3/2/26.
//

import Foundation

@Observable
final class StackGameOperationViewModel {
    // MARK: - Engine
    private var game = StackGame()
    
    // MARK: - UI State
    var stackItems: [Int] = []
    var target: Int = 0
    var hasWon: Bool = false
    
    // Numbers generated for UI buttons - observable!
    var generatedNumbers: [Int] = []
    
    var availableNumbers: [Int] {
        generatedNumbers
    }
    
    
    // MARK: - Initialization
    init() {
        startNewGame()
    }
    
    // MARK: - Game Setup
    func startNewGame() {
        hasWon = false
        game = StackGame()
        stackItems = []
        generateNumbers()
        generateLevel()
    }
    
    private func generateNumbers() {
        // Always generate exactly 4 numbers
        generatedNumbers = (1...4).map { _ in Int.random(in: 1...9) }
    }
    
    // MARK: - User Actions
    func perform(_ action: StackGameAction) {
        guard !hasWon else { return }
        game.applyOp(action)
        stackItems = game.currentStack
        checkWinCondition()
    }
    
    // MARK: - Win Logic
    private func checkWinCondition() {
        if game.top == target {
            hasWon = true
        }
    }
    
    // MARK: - Level Generation
    private func generateLevel(moveCount: Int = 6) {
        let maxAttempts = 100
        var attempts = 0
        var foundTarget = false
        
        while attempts < maxAttempts && !foundTarget {
            attempts += 1
            let simulatedGame = StackGame()
            var simGame = simulatedGame
            
            for _ in 0..<moveCount {
                let actions = availableActions(simulatedNumbers: generatedNumbers, for: simGame)
                guard let action = actions.randomElement() else { continue }
                simGame.applyOp(action)
            }
            
            if let top = simGame.top, top > 3 && top < 100 {
                target = top
                foundTarget = true
            }
        }
        
        // fallback if simulation fails
        if !foundTarget {
            target = generatedNumbers.randomElement()!
        }
        
        // shuffle numbers for UI
        generatedNumbers.shuffle()
    }
    
    private func availableActions(simulatedNumbers: [Int], for gameInstance: StackGame) -> [StackGameAction] {
        var actions: [StackGameAction] = []

        // ALWAYS include the 4 numbers, regardless of stack state
        actions.append(contentsOf: generatedNumbers.map { StackGameAction.number($0) })

        // Then add operation buttons if applicable
        if gameInstance.currentStack.count >= 1 {
            actions.append(.double)
            actions.append(.cancel)
        }
        if gameInstance.currentStack.count >= 2 {
            actions.append(.add)
        }
        return actions
    }
}
