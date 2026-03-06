//
//  StringReversalView.swift
//  TheStackLab
//
//  Created by D F on 3/1/26.
//

import SwiftUI

struct StringReversalView: View {
    @State private var debounceVM = DebouncedInputViewModel { _ in true }
    @State private var stringReversalVM = StringReversalViewModel()
    @State private var timer: Timer? = nil
    
    
    func startAnimation(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            if stringReversalVM.currentStepIndex < stringReversalVM.steps.count {
                withAnimation {
                    stringReversalVM.performNextStep()
                }
            } else {
                timer?.invalidate()
            }
            
        }
    }
    
    func resetAnimation() {
        timer?.invalidate()
        withAnimation {
            stringReversalVM.reset()
        }
    }
    
    var body: some View {
        VStack(spacing:40){
            VStack(alignment: .leading, spacing: 15) {
                Text("Input string for reversal".capitalized)
                    .font(.system(size:20, weight:.bold))
                    .foregroundColor(Color.midnight950.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("", text: $debounceVM.input, prompt: Text("Enter text").foregroundColor(.white.opacity(0.6)))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .fill(Color.midnight950)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .foregroundColor(.white)
                    .tint(.white)
                
                Text("\( stringReversalVM.reversedInstantly)")
                    .font(.system(size:16, weight:.medium))
                    .italic()
                    .foregroundColor(Color.midnight950.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .animation(.easeInOut(duration:0.3), value:stringReversalVM.reversedInstantly)
                
            }
            .padding()
            .onChange(of: debounceVM.debouncedInput) { _,newValue in
                stringReversalVM.reverseInstantly(newValue)
            }
            
            Spacer()
            
            VStack{
                Text("Stack")
                    .font(.system(size:20, weight:.bold))
                    .foregroundColor(Color.midnight950.opacity(0.5))
                
                ZStack {
                    if stringReversalVM.stackItems.isEmpty {
                        Text("Stack is currently empty")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(8)
                            .transition(.opacity)
                    }
                    else {
                        ScrollView {
                            HStack(spacing:6) {
                                ForEach(Array(stringReversalVM.stackItems.enumerated()), id: \.offset) { _, char in
                                    
                                    Text(String(char))
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(width: 50, height: 50)
                                        .background(Color.midnight950.opacity(0.8))
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                        .animation(.easeInOut(duration: 0.3), value: stringReversalVM.stackItems)
                                }
                            }
                        }
                        .frame(height: 60)
                    }
                }
                
                
                Divider()
                
                VStack {
                    Text("Reversed String")
                        .font(.system(size:20, weight:.bold))
                        .foregroundColor(Color.midnight950.opacity(0.5))
                    
                    Text(stringReversalVM.reversedString)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.midnight950)
                        .padding(.top, 10)
                }
                .padding(.top, 30)
                
                Divider()
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button("Start") { startAnimation() }
                        .stackButtonStyle()
                    Button("Reset") { resetAnimation() }
                        .stackButtonStyle()
                }
            }
            .padding()
            .onChange(of: debounceVM.debouncedInput) { _,newValue in
                stringReversalVM.prepareSteps(for: newValue)
                resetAnimation()
            }
            .padding(.bottom, 60)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack(alignment: .center) {
        Color.midnight100
            .ignoresSafeArea()
        StringReversalView()
    }
}
