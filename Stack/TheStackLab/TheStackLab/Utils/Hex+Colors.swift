//
//  Hex+Colors.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

extension Color {
    init(hex:String) {
        // Remove non-alphanumeric characters (#, spaces, etc.)
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        var r,g,b, a: Double
        
        switch hex.count {
        case 3: // Short RGB, e.g., "F80" -> "FF8800"
            r = Double((int >> 8) & 0xF) / 15
            g = Double ((int >> 4) & 0xF) / 15
            b = Double ((int & 0xF)) / 15
            a = 1.0
            
        case 6: // Standard RGB, e.g., "FF8800"
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
            a = 1.0
            
        case 8: // RGBA, e.g., "FF8800FF"
            r = Double((int >> 24) & 0xFF) / 255
            g = Double((int >> 16) & 0xFF) / 255
            b = Double((int >> 8) & 0xFF) / 255
            a = Double(int & 0xFF) / 255
            
        default: // Invalid, default to white
            r = 1
            g = 1
            b = 1
            a = 1
        }
        
        self.init(red: r, green: g, blue : b, opacity: a)
    }
}
