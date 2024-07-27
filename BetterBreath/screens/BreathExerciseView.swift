//
//  BreathExerciseView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import SwiftUI

struct BreathExerciseView: View {
    
    var breathExercise: BreathExercise
    
    @State private var scale: CGFloat = 0.0 // Start small
    
    private func animateCircle() {
        withAnimation(.easeInOut(duration: breathExercise.inBreathDuration)) {
            scale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration) {
            withAnimation(.easeInOut(duration: breathExercise.outBreathDuration)) {
                scale = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration + breathExercise.outBreathDuration + breathExercise.emptyHoldDuration) {
            
            animateCircle()
        }
    }
    
    
    var body: some View {
        Text("Breath \(String(format: "%.1f", breathExercise.inBreathDuration)) - \(String(format: "%.1f", breathExercise.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExercise.outBreathDuration)) - \(String(format: "%.1f", breathExercise.emptyHoldDuration))")
        
        GeometryReader { geometry in
            // Using ZStack to overlay circles
            ZStack {
                // Outer circle
                Circle()
                    .strokeBorder(Color.blue, lineWidth: 2)
                    .frame(width: min(geometry.size.width * 0.75, 300),
                           height: min(geometry.size.width * 0.75, 300))
                
                // Inner circle, smaller, adjust the size as needed
                Circle()
                    .fill(Color.blue)
                    .scaleEffect(scale) // Use scale to animate size
                    .frame(width: min(geometry.size.width * 0.75, 300), // Smaller size
                           height: min(geometry.size.width * 0.75, 300))
                    .onAppear {
                        animateCircle()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering in GeometryReader
        }
        .edgesIgnoringSafeArea(.all) // Optional, to use the entire screen space if needed
        
        TimerView()
    }
}



#Preview {
    BreathExerciseView(breathExercise: BreathExercise(
        createdAt: Date(),
        inBreathDuration: 5.0,
        fullBreathHoldDuration: 0.0,
        outBreathDuration: 0.0,
        emptyHoldDuration: 5.0,
        name: "Breath exercise"
    ))
    .modelContainer(for: BreathExercise.self, inMemory: true)
}

