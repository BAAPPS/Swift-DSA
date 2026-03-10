//
//  SplashScreenView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/9/26.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack{
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .frame(width:150, height:100)
                .foregroundColor(Color.pickledBluewood700)
            Text("TheMonotonicLab")
                .gloriaHallelujah(size: 40)
                .foregroundColor(Color.pickledBluewood900)
        }
    }
}

#Preview {
    ZStack {
        Color.pickledBluewood200
            .ignoresSafeArea()
        SplashScreenView()
    }
}
