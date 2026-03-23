//
//  TemperatureResult.swift
//  TheMonotonicLab
//
//  Created by D F on 3/17/26.
//

import Foundation


struct TemperatureResult {
    var days: Int
    var previousValue: Int
    let nextValue: Int
}

extension TemperatureResult {
    var currentValue: Int {
        return nextValue
    }
}
