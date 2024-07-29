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
    
    
    var breathExercise: BreathExercise
    
    @State private var scale: CGFloat = 0.0 // Start small
    
    private func animateCircle() {
        if !isActive { return }
        
        
        withAnimation(.easeInOut(duration: breathExercise.inBreathDuration)) {
            scale = 1.0
        }
        
        withAnimation(.easeInOut(duration: breathExercise.outBreathDuration).delay(breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration)) {
            scale = 0.0
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

