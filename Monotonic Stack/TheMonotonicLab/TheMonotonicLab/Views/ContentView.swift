//
//  ContentView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var splashScale: CGFloat = 0.8
    @State private var splashOpacity: Double = 0.0
    
    @State private var weatherVM = WeatherViewModel()
    @State private var showGreaterTempSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                Color.pickledBluewood200
                    .ignoresSafeArea()
                
                if !showSplash {
                    WeatherView()
                        .environment(weatherVM)
                }
                
                if showSplash {
                    SplashScreenView()
                        .scaleEffect(splashScale)
                        .opacity(splashOpacity)
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .onAppear {
                            
                            withAnimation(.easeInOut(duration:1.0)) {
                                splashScale = 1.0
                                splashOpacity = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    RefreshButtonView()
                        .environment(weatherVM)
                    
                    Button {
                        weatherVM.computeNextGreaterDays()
                        weatherVM.computeNextSmallerDays()
                        showGreaterTempSheet = true
                    } label: {
                        Image(systemName: "chart.bar.doc.horizontal")
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            
            .sheet(isPresented: $showGreaterTempSheet) {
                NavigationStack {
                    NextWeatherInfoView()
                        .environment(weatherVM)
                        .navigationTitle("Temperature Info")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showGreaterTempSheet = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.pickledBluewood200)
                                        .frame(width: 32, height: 32)
                                        .background(Color.pickledBluewood950.opacity(0.8))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
