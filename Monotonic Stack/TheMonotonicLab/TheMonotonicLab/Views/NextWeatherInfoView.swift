//
//  NextWeatherInfoView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/16/26.
//

import SwiftUI

struct NextWeatherInfoView: View {
    @Environment(WeatherViewModel.self) var weatherVM
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing:5) {
                Spacer().frame(height:40)
                Text("Days Until Greater Temperature")
                    .gloriaHallelujah(size: 23)
                    .padding(.top, 25)
                
                NextWeatherScrollView(days: weatherVM.nextGreaterDays)
                    .environment(weatherVM)
                
                VStack(spacing:5) {
                    
                    Text("Days Untl Lower Temperature")
                        .gloriaHallelujah(size:23)
                    
                    NextWeatherScrollView(days: weatherVM.nextSmallerDays)
                        .environment(weatherVM)
                }
            }
        }
    }
}

#Preview {
    NextWeatherInfoView()
        .environment(WeatherViewModel.preview)
}
