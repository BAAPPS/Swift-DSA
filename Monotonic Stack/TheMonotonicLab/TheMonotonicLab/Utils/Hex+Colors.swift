//
//  Hex+Colors.swift
//  TheMonotonicLab
//
//  Created by D F on 3/9/26.
//

import SwiftUI

extension Color {
    init(hex:String) {
        let hex = hex.trimmingCharacters(in:CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string:hex).scanHexInt64(&int)
        
        var r,g,b,a:Double
        
        switch hex.count {
        case 6:  // Standard RGB, e.g., "FF8800"
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
            a = 1.0
        default: // Invalid, default to white
            r = 1
            g = 1
            b = 1
            a = 1
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
