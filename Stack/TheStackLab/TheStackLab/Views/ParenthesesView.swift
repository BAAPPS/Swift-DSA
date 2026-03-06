//
//  ParenthesesView.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

struct ParenthesesView: View {
    @State private var debounceVM = DebouncedInputViewModel {
        "[](){}".contains($0)
    }
    @State private var validatorVM = ParenthesesViewModel()
    
    var body: some View {
        ZStack {
            
            BackgroundGradientView(
                isActive: !debounceVM.input.isEmpty,
                isValid: validatorVM.isValid )
            
            VStack(spacing: 10) {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Enter Parentheses", text: $debounceVM.input)
                }
                .padding()
                .validationOverlay(
                    isActive: !debounceVM.input.isEmpty,
                    isValid: validatorVM.isValid)
                .animation(.easeInOut(duration: 0.25), value: debounceVM.input)
                .onChange(of : debounceVM.debouncedInput) {
                    _ , value in  validatorVM.validateAndVisualize(value)
                }
                Divider()
                Spacer()
                VStack{
                    Text("Stack Visualization")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 8) {
                            if validatorVM.stackItems.isEmpty {
                                Text("Empty Stack")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .padding(8)
                                
                            } else {
                                ForEach(Array(validatorVM.stackItems), id: \.self) { char in
                                    Text(String(char))
                                        .font(.title)
                                        .padding(8)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight:300)
                .padding(.top, 10)
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ParenthesesView()
}
