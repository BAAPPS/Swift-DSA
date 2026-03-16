//
//  RefreshButtonView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/12/26.
//

import SwiftUI

struct RefreshButtonView: View {
    @Environment(WeatherViewModel.self) var weatherVM
    @State private var isSpinning = false
    var body: some View {
        Button {
            Task {
                isSpinning = true
                await weatherVM.loadWeather()
                isSpinning = false
                
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                .animation(
                    isSpinning
                    ? Animation.linear(duration: 1).repeatForever(autoreverses: false)
                    : .default,
                    value: isSpinning
                )
        }
    }
}

#Preview {
    NavigationStack {
        RefreshButtonView()
            .environment(WeatherViewModel())
    }
    
}
