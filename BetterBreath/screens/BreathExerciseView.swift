//
//  BreathExerciseView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import AVFoundation
import SwiftData
import SwiftUI

struct BreathExerciseView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isActive = true
    @State private var timeElapsed = 0.0
    @State private var vibrate = false
    @Environment(\.modelContext) private var modelContext

    @Query private var users: [User]
    var user: User? { users.first }

    @State private var audioEnabled = true

    func initSound() {
        audioEnabled = user?.breathSoundEnabled ?? true
    }

    var breathExercise: BreathExercise

    @State private var scale: CGFloat = 0.0 // Start small

    private func queuVibrations(totalDuration: Double) {
        if !vibrate { return }

        let numIntervals = 10

        let interval = totalDuration / Double(numIntervals - 1)
        for i in 0 ..< numIntervals {
            let easedTime = InOutQuadBlend(t: Double(i) * interval / totalDuration) * totalDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + easedTime) {
                self.playChime()
            }
        }
    }

    private func animateCircle() {
        if !isActive { return }

        withAnimation(.easeInOut(duration: breathExercise.inBreathDuration)) {
            queuVibrations(totalDuration: breathExercise.inBreathDuration)
            playInBreath(duration: breathExercise.inBreathDuration)
            scale = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration) {
            withAnimation(.easeInOut(duration: breathExercise.outBreathDuration)) {
                scale = 0.0
                playOutBreath(duration: breathExercise.outBreathDuration)
                queuVibrations(totalDuration: breathExercise.outBreathDuration)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + breathExercise.inBreathDuration + breathExercise.fullBreathHoldDuration + breathExercise.outBreathDuration + breathExercise.emptyHoldDuration) {
            animateCircle()
        }
    }

    func playAudio(resource: String, ext: String, targetDuration: Double? = nil) {
        initSound()
        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: ext) else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)

            let originalTime = audioPlayer?.duration

            if targetDuration != nil && originalTime != nil {
                let ratio = originalTime! / targetDuration!

                audioPlayer?.enableRate = true
                audioPlayer?.rate = Float(ratio)
            }

            if !audioEnabled {
                audioPlayer?.volume = 0.0
            }

            audioPlayer?.play()
        } catch {
            print("Could not load file \(resource).\(ext): \(error)")
        }
    }

    func playInBreath(
        duration: Double
    ) {
        if !isActive { return }
        playAudio(resource: "in_breath", ext: "mp3", targetDuration: duration)
    }

    func playOutBreath(
        duration: Double
    ) {
        if !isActive { return }
        playAudio(resource: "out_breath", ext: "mp3", targetDuration: duration)
    }

    func playChime() {
        if !isActive { return }

        playAudio(resource: "chime", ext: "wav")
    }

    func checkTimeAndTriggerFunction(time: Double) {
        if time >= breathExercise.exerciseDuration {
            playChime()
            isActive = false
        }
    }

    func onViewUnmount() {
        isActive = false
        audioPlayer?.stop()
    }

    var body: some View {
        NavigationStack {
            Text("Pattern \(String(format: "%.1f", breathExercise.inBreathDuration)) - \(String(format: "%.1f", breathExercise.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExercise.outBreathDuration)) - \(String(format: "%.1f", breathExercise.emptyHoldDuration))")
                .onDisappear {
                    onViewUnmount()
                }

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
                        .scaleEffect(scale)
                        .frame(width: min(geometry.size.width * 0.75, 300), // Smaller size
                               height: min(geometry.size.width * 0.75, 300))
                        .onAppear {
                            animateCircle()
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
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if audioEnabled {
                        audioPlayer?.volume = 0.0
                        audioEnabled = false
                        let newUser = User(breathSoundEnabled: false)
                        modelContext.insert(newUser)
                    } else {
                        audioPlayer?.volume = 1.0
                        audioEnabled = true
                        let newUser = User(breathSoundEnabled: true)
                        modelContext.insert(newUser)
                    }

                }) {
                    Image(systemName: audioEnabled ? "speaker.wave.2.circle.fill" : "speaker.slash.circle.fill")
                        .imageScale(.large)
                        .font(.system(size: 24))
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
            }
        }
        .onAppear(perform: initSound)
    }
}

#Preview {
    BreathExerciseView(breathExercise: BreathExercise(
        createdAt: Date(),
        inBreathDuration: 5.0,
        fullBreathHoldDuration: 0.0,
        outBreathDuration: 0.0,
        emptyHoldDuration: 5.0,
        exerciseDuration: 60.0,
        name: "Breath exercise"
    ))
    .modelContainer(for: BreathExercise.self, inMemory: true)
}
