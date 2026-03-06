//
//  SplashScreenView.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack{
            Image(systemName: "rectangle.stack")
                .resizable()
                .frame(width:100, height: 100)
                .foregroundColor(.midnight950)
            Text("TheStackLab")
                .font(.largeTitle)
        }
    }
}

#Preview {
    SplashScreenView()
}
