//
//  NextWeatherScrollView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/17/26.
//

import SwiftUI

struct NextWeatherScrollView: View {
    @Environment(WeatherViewModel.self) var weatherVM
    let days: [TemperatureResult]
    var body: some View {
        
        if days.isEmpty {
            Text("No data available")
                .foregroundColor(.gray)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:10) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, result in
                        VStack(spacing:5) {
                            Text(weatherVM.formatDays(result.days))
                                .font(.title2)
                                .bold()
                            
                            if result.nextValue == -1 {
                                Text("-")
                                    .gloriaHallelujah(size:19)
                                    .foregroundColor(Color.pickledBluewood900)
                            } else if result.previousValue != -1 {
                                // Show previous → next
                                Text("\(result.previousValue) → \(result.nextValue)°")
                                    .gloriaHallelujah(size: 19)
                                    .foregroundColor(Color.pickledBluewood900)
                            } else {
                                // Only next value is available
                                Text("\(result.nextValue)°")
                                    .gloriaHallelujah(size: 19)
                                    .foregroundColor(Color.pickledBluewood900)
                            }
                            
                            Text("Day \(index + 1)")
                                .font(.caption)
                            
                        }
                        .padding()
                        .background(result.days == -1 ? Color.gray.opacity(0.2) : Color.pickledBluewood800.opacity(0.3))
                        .cornerRadius(10)
                        
                    }
                }
                .padding()
            }
        }
        
    }
}

#Preview {
    NextWeatherScrollView(days: WeatherViewModel.preview.nextGreaterDays)
        .environment(WeatherViewModel.preview)
}
