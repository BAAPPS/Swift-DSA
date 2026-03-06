//
//  DebouncedInputViewModel.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import Foundation
import SwiftUI

@Observable
final class DebouncedInputViewModel {
    var input: String = "" {
        didSet {
            // Only allow parentheses characters
            let filtered = input.filter(allowedCharacters)
            if filtered != input {
                input = filtered   // only assign if different
            }
            debounceValidate()
        }
    }
    var debouncedInput: String = "" // updates after debounce
    
   
    private let allowedCharacters: (Character) -> Bool
    private var debounceTask: Task<Void, Never>? = nil

    init(allowedCharacters: @escaping (Character) -> Bool) {
        self.allowedCharacters = allowedCharacters
    }
    
    private func  debounceValidate() {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard let self else { return }
            await MainActor.run {
                self.debouncedInput = self.input
            }
            
        }
    }
}
