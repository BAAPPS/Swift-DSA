//
//  ContentView.swift
//  TheStackLab
//
//  Created by D F on 1/26/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var splashScale: CGFloat = 0.8
    @State private var splashOpacity: Double = 0.0
    var body: some View {
        ZStack(alignment: .center) {
            Color.midnight100
                .ignoresSafeArea()
            if !showSplash {
                CustomTabBarView()
                .transition(.opacity)
            }
            
            if showSplash {
                SplashScreenView()
                    .scaleEffect(splashScale)
                    .opacity(splashOpacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
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
