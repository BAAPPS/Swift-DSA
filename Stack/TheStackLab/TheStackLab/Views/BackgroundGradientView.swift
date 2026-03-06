//
//  BackgroundGradientView.swift
//  TheStackLab
//
//  Created by D F on 3/1/26.
//

import SwiftUI

struct BackgroundGradientView: View {
    var isActive: Bool
    var isValid: Bool
   
    @State private var animateGradient = false
    
    private var gradient: LinearGradient {
        guard isActive else {
            return LinearGradient(
                colors: [.clear, .clear],
                startPoint: .top,
                endPoint: .bottom)
        }
        
        let base = isValid ? Color.green : Color.red
        
        return LinearGradient(
            colors: [base.opacity(0.6), base.opacity(0.9)],
            startPoint: animateGradient ? .topLeading : .top,
            endPoint: animateGradient ? .bottomTrailing :  .bottom )
        
    }
    var body: some View {
        Rectangle()
            .fill(gradient)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: isValid)
            .animation(.easeInOut(duration: 0.2), value: isActive)
            .onAppear {
                withAnimation(.linear(duration:3).repeatForever(autoreverses:true)){
                    animateGradient.toggle()
                }
            }
    }
}

#Preview {
   
    BackgroundGradientView(isActive: true, isValid: true)
}
