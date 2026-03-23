//
//  PreviousWeatherScrollView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/23/26.
//

import SwiftUI

struct PreviousWeatherScrollView: View {
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
                            
                            Text(weatherVM.formatDaysAgo(result.days))
                            
                            if result.previousValue != -1 {
                                Text("\(result.previousValue)°")
                                    .gloriaHallelujah(size: 19)
                                    .foregroundColor(Color.pickledBluewood900)
                            }
                            
                            
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
    PreviousWeatherScrollView(days: WeatherViewModel.preview.previousSmallerDays)
        .environment(WeatherViewModel.preview)
}
