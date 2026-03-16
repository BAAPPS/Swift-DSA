//
//  NextWeatherInfoView.swift
//  TheMonotonicLab
//
//  Created by D F on 3/16/26.
//

import SwiftUI

struct NextWeatherInfoView: View {
    @Environment(WeatherViewModel.self) var weatherVM
    @Binding var showGreaterTempSheet: Bool
    var body: some View {
        ZStack {
            VStack(spacing:20) {
                Spacer().frame(height:40)
                Text("Days Until Greater Temperature")
                    .gloriaHallelujah(size: 23)
                    .padding(.top, 25)
                
                if weatherVM.nextGreaterDays.isEmpty {
                    Text("No data available")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing:10) {
                            ForEach(Array(weatherVM.nextGreaterDays.enumerated()), id:\.offset) { index, days in
                                VStack(spacing:5) {
                                    Text("\(days)")
                                        .font(.title3)
                                        .bold()
                                    Text("Days \(index + 1)")
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color.pickledBluewood800.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                showGreaterTempSheet = false
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.pickledBluewood200)
                    .padding()
                    .background(Color.pickledBluewood950.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NextWeatherInfoView(showGreaterTempSheet: .constant(false))
        .environment(WeatherViewModel())
}
