//
//  BreathExerciseView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import SwiftUI
import AVFoundation

struct BreathExerciseView: View {
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isActive = true
    @State private var timeElapsed = 0.0
    @State private var vibrate = false
    
    
    var breathExercise: BreathExercise
    
    @State private var scale: CGFloat = 0.0 // Start small
    
    private func queuVibrations(totalDuration: Double ) {
        if !vibrate { return }
        print("QueueVibrations")
        
        let numIntervals = 10
        
        let interval = totalDuration / Double(numIntervals - 1)
        for i in 0..<numIntervals {
            let easedTime = InOutQuadBlend(t: Double(i) * interval / totalDuration) * totalDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + easedTime) {
                self.playChime()
            }
        }
    }
    
    private func bezierBlend(t: Double) -> Double {
        return t * t * (3 - 2 * t);
    }
    
    private func InOutQuadBlend(t: Double) -> Double {
        
        if(t <= 0.5) {
            return 2 * t * t
        }
        
        let modT = t - 0.5;
        return 2 * modT * (1 - modT) + 0.5;
    }
    
    
    // Double check is correct
    private func easeInOut(t: Double) -> Double {
        // This is a simple easeInOut function using a cubic polynomial expression
        return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2
    }
    
    private func animateCircle() {
        if !isActive { return }
        
        
        
        withAnimation(.easeInOut(duration: breathExercise.inBreathDuration)) {
            
            queuVibrations(totalDuration: breathExercise.inBreathDuration)
            scale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration) {
            withAnimation(.easeInOut(duration: breathExercise.outBreathDuration)) {
                scale = 0.0
                queuVibrations(totalDuration: breathExercise.outBreathDuration)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration + breathExercise.outBreathDuration + breathExercise.emptyHoldDuration) {
            
            animateCircle()
        }
    }
    
    func playChime() {
        if !isActive { return }
        
        guard let soundURL = Bundle.main.url(forResource: "chime", withExtension: "wav") else {
            print("Sound file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error)")
        }
    }
    
    func checkTimeAndTriggerFunction(time: Double) {
        if time >= breathExercise.exerciseDuration {
            playChime()
            isActive = false
        }
    }
    
    
    var body: some View {
        Text("Pattern \(String(format: "%.1f", breathExercise.inBreathDuration)) - \(String(format: "%.1f", breathExercise.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExercise.outBreathDuration)) - \(String(format: "%.1f", breathExercise.emptyHoldDuration))")
        
        GeometryReader { geometry in
            // Using ZStack to overlay circles
            ZStack {
                // Outer circle
                Circle()
                    .strokeBorder(Color.blue, lineWidth: 2)
                    .frame(width: min(geometry.size.width * 0.75, 300),
                           height: min(geometry.size.width * 0.75, 300))
                
                // Inner circle
                Circle()
                    .fill(Color.blue)
                    .scaleEffect(scale) // Use scale to animate size
                    .frame(width: min(geometry.size.width * 0.75, 300), // Smaller size
                           height: min(geometry.size.width * 0.75, 300))
                    .onAppear {
                        animateCircle()
                    }
                    .onDisappear {
                        self.isActive = false
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
        
        HStack {
            TimerView(timeElapsed: $timeElapsed, isActive: $isActive)
                .onChange(of: timeElapsed) { newValue in
                    checkTimeAndTriggerFunction(time: newValue)
                }
            Text("/")
            TimerView(timeElapsed: .constant(breathExercise.exerciseDuration), isActive: .constant(false))
        }
    }
}



#Preview {
    BreathExerciseView(breathExercise: BreathExercise(
        createdAt: Date(),
        inBreathDuration: 5.0,
        fullBreathHoldDuration: 0.0,
        outBreathDuration: 0.0,
        emptyHoldDuration: 5.0,
        exerciseDuration:  60.0,
        name: "Breath exercise"
    ))
    .modelContainer(for: BreathExercise.self, inMemory: true)
}

