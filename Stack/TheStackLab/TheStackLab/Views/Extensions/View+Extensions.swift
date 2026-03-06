//
//  View+Extensions.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//


import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
    
}

struct ValidationOverlayModifier: ViewModifier {
    var isActive: Bool
    var isValid: Bool
    
    func body(content:Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isActive {
                    Image(systemName: isValid  ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(.white.opacity(0.2))
                        .scaleEffect(isValid ? 1.05 : 0.9)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isValid)
                        .transition(.scale.combined(with:.opacity))
                        .offset(y: -70)
                        .opacity(isActive ? 1 : 0)
                }
            }
            .animation(.easeInOut(duration: 0.25),value: isActive)
    }
}

// Configurable ViewModifier
struct StackButtonStyle: ViewModifier {
    var width: CGFloat = 80
    var height: CGFloat = 60
    var background: Color = .midnight950

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: width, minHeight: height)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(background)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .tint(.white)
            .bold()
    }
}



extension View {
    func cornerRadiusModifier(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius:radius, corners: corners))
    }
    
    func validationOverlay(isActive: Bool, isValid: Bool) -> some View {
        self.modifier(ValidationOverlayModifier(isActive: isActive, isValid: isValid))
    }
    
    func stackButtonStyle(width: CGFloat = 80, height: CGFloat = 60, background: Color = .midnight950) -> some View {
        self.modifier(StackButtonStyle(width: width, height: height, background: background))
    }
}
