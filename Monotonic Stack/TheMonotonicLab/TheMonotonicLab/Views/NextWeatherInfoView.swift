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
                Text("Days Until Higher Temperature")
                    .gloriaHallelujah(size: 23)
                    .padding(.top, 25)
                
                NextWeatherScrollView(days: weatherVM.nextGreaterDays)
                    .environment(weatherVM)
                
                VStack(spacing:5) {
                    
                    Text("Days Until Lower Temperature")
                        .gloriaHallelujah(size:23)
                    
                    NextWeatherScrollView(days: weatherVM.nextSmallerDays)
                        .environment(weatherVM)
                }
                
                VStack(spacing:5) {
                    Text("Previous Lower Temperature Days")
                        .gloriaHallelujah(size:23)
                    PreviousWeatherScrollView(days: weatherVM.previousSmallerDays)
                }
                
                VStack(spacing:5) {
                    Text("Previous Higher Temperature Days")
                        .gloriaHallelujah(size:23)
                    PreviousWeatherScrollView(days: weatherVM.previousGreaterDays)
                }
                
            }
        }
    }
}

#Preview {
    NextWeatherInfoView()
        .environment(WeatherViewModel.preview)
}
