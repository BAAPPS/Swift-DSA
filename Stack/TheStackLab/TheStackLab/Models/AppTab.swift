//
//  AppTabs.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import Foundation

enum AppTab: Int, CaseIterable, Identifiable {
    case validate
    case reverse
    case game
    var id: Int {rawValue}
    
    var title: String{
        switch self {
        case .validate: return "Validator"
        case .reverse: return "Reversal"
        case .game: return "Game"
        }
    }
    var systemIcon: String {
        switch self {
        case .validate: return "parentheses"
        case .reverse: return "arrow.uturn.left"
        case .game: return "gamecontroller.circle"
        }
    }
}
