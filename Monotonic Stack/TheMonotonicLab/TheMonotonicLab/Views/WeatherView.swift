//
//  WeatherView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import SwiftUI

struct WeatherView: View {
    @Environment(WeatherViewModel.self) var weatherVM
    var body: some View {
        @Bindable var weatherVM = weatherVM
        VStack(spacing:20) {
            
            
            VStack(alignment:.leading, spacing:10){
                Text("Enter City")
                    .gloriaHallelujah(size: 25)
                
                
                TextField("", text: $weatherVM.city, prompt:
                            Text("Enter city")
                    .foregroundColor(.pickledBluewood200)
                )
                .padding(.horizontal)
                .frame(maxWidth:.infinity, minHeight:60)
                .foregroundColor(.pickledBluewood200)
                .background(
                    RoundedRectangle(cornerRadius:10)
                        .fill(Color.pickledBluewood800)
                        .shadow(color: .black.opacity(0.4),radius:8, x:0, y:4)
                )
            }
            .padding()
            
            Button(action:  {
                Task {
                    await weatherVM.loadWeather()
                }
            }) {
                Text("Get Weather")
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.pickledBluewood400)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }
            .padding(.horizontal)
            
            Divider()
            
            if !weatherVM.allTemperatures.isEmpty && weatherVM.currentTemperature != "" {
                VStack(spacing:20) {
                    if weatherVM.weather != nil {
                        VStack(spacing: 10) {
                            Text("Weather in \(weatherVM.city)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.pickledBluewood800)
                                .padding(.top, 20)
                            
                            HStack {
                                Text("Current Temp:")
                                Text(weatherVM.currentTemperature)
                                    .bold()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing:10){
                                    ForEach(Array(weatherVM.allTemperatures.enumerated()), id: \.offset){ _,temp in
                                        VStack {
                                            Text("\(Int(temp))°")
                                                .font(.title2)
                                                .bold()
                                        }
                                        .padding()
                                        .foregroundColor(.pickledBluewood950)
                                        .background(Color.pickledBluewood800.opacity(0.3))
                                        .cornerRadius(8)
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            if let error = weatherVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
            
            
        }
        .onAppear {
            Task {
                await weatherVM.loadWeather() // loading default city on start
            }
        }
    }
}

#Preview {
    ZStack{
        Color.pickledBluewood200
            .ignoresSafeArea()
        WeatherView()
            .environment(WeatherViewModel())
    }
}
