//
//  View+Extensions.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import SwiftUI

struct GloriaHFont: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom("GloriaHallelujah-Regular", size: size))
    }
}

extension View {
    func gloriaHallelujah(size: CGFloat) -> some View {
        self.modifier(GloriaHFont(size: size))
    }
}
