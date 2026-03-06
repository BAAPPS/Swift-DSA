//
//  StackGameOperationView.swift
//  TheStackLab
//
//  Created by D F on 3/2/26.
//

import SwiftUI

struct StackGameOperationView: View {
    @State private var viewModel = StackGameOperationViewModel()
    
    
    // MARK: Operation Button Style
    struct OperationButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .padding()
                .background(configuration.isPressed ? Color.orange.opacity(0.7) : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Target Number
            VStack {
                Text("Target")
                    .font(.headline)
                    .foregroundColor(.midnight950.opacity(0.5))
                
                Text("\(viewModel.target)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.midnight950)
                    .shadow(radius: 4)
                
                // MARK: Win Message
                if viewModel.hasWon {
                    Text("🎉 You reached the target! 🎉")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.midnight950)
                        .transition(.scale)
                }
            }
            .padding(.top, 20)
            ScrollView {
                LazyVStack(spacing: 12){
                    if viewModel.stackItems.isEmpty {
                        Text("Stack is empty")
                            .foregroundColor(.white)
                            .padding(8)
                            .frame(width: 200, height:50)
                            .background(Color.midnight950)
                            .cornerRadius(6)
                    }
                    else {
                        Text("TOP")
                        ForEach(Array(viewModel.stackItems.reversed()), id: \.self) { item in
                       
                            Text("\(item)")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding(8)
                                .frame(width: 200, height:50)
                                .background(Color.midnight950)
                                .cornerRadius(6)
                        }
                        Text("BOTTOM")
                    }
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(height: 300)
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: viewModel.availableNumbers.count), spacing: 5) {
                ForEach(viewModel.availableNumbers, id:\.self) { number in
                    
                    Button(action: {
                        viewModel.perform(.number(number))
                    }) {
                        Text("\(number)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: 400)
            .frame(maxWidth: .infinity)
            
            HStack{
                Button("+") {
                    viewModel.perform(.add)
                }
                .disabled(viewModel.stackItems.count < 2)
                .buttonStyle(OperationButtonStyle())
                
                Button("×2") {
                    viewModel.perform(.double)
                }
                .disabled(viewModel.stackItems.isEmpty)
                .buttonStyle(OperationButtonStyle())
                
                Button("❌") {
                    viewModel.perform(.cancel)
                }
                .disabled(viewModel.stackItems.isEmpty)
                .buttonStyle(OperationButtonStyle())
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            // MARK: New Game Button
            Button("New Game") {
                viewModel.startNewGame()
            }
            .padding()
            .background(Color.green.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    ZStack(alignment: .center) {
        Color.midnight100
            .ignoresSafeArea()
        StackGameOperationView()
    }
}
