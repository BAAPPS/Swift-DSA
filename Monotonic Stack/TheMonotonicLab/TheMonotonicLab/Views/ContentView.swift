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
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
