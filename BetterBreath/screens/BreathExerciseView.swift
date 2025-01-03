import AVFoundation
import SwiftData
import SwiftUI

private enum ExerciseStatus {
    case not_started
    case inBreath
    case inHold
    case outBreath
    case outHold
    case paused
    case finished

    var isPlaying: Bool {
        self == .inBreath || self == .inHold || self == .outBreath || self == .outHold
    }
}

struct BreathExerciseView: View {
    @State private var exerciseStatus = ExerciseStatus.not_started
    @State private var audioPlayer: AVAudioPlayer?
    @State private var timeElapsed = 0.0
    @State private var vibrate = false
    @Environment(\.modelContext) private var modelContext

    @Query private var users: [User]
    var user: User? { users.first }

    @State private var audioEnabled = true

    func onViewApper() {
        UIApplication.shared.isIdleTimerDisabled = true
        initSound()
    }

    func initSound() {
        audioEnabled = user?.breathSoundEnabled ?? true
    }

    var breathExerciseTemplate: BreathExerciseTemplate

    @State private var scale: CGFloat = 0.0

    @State private var breathExercise: BreathExercise? = nil

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

    private func loopExerciseCycle() {
        if !exerciseStatus.isPlaying { return }

        withAnimation(.easeInOut(duration: breathExerciseTemplate.inBreathDuration)) {
            queuVibrations(totalDuration: breathExerciseTemplate.inBreathDuration)
            playInBreath(duration: breathExerciseTemplate.inBreathDuration)
            scale = 1.0
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + breathExerciseTemplate.inBreathDuration + breathExerciseTemplate.fullBreathHoldDuration,
            qos: .userInteractive
        ) {
            withAnimation(.easeInOut(duration: breathExerciseTemplate.outBreathDuration)) {
                scale = 0.0
                playOutBreath(duration: breathExerciseTemplate.outBreathDuration)
                queuVibrations(totalDuration: breathExerciseTemplate.outBreathDuration)
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + breathExerciseTemplate.inBreathDuration + breathExerciseTemplate.fullBreathHoldDuration + breathExerciseTemplate.outBreathDuration + breathExerciseTemplate.emptyHoldDuration,
            qos: .userInteractive
        ) {
            if isExerciseFinished(time: timeElapsed) {
                finishExercise()
            } else {
                loopExerciseCycle()
            }
        }
    }

    func playAudio(resource: String, ext: String, targetDuration: Double? = nil) {
        initSound()

        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the category to playback so it can play even in silent mode
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }

        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("NO SOUND URL")
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
        if !exerciseStatus.isPlaying { return }
        playAudio(resource: "in_breath", ext: "mp3", targetDuration: duration)
    }

    func playOutBreath(
        duration: Double
    ) {
        if !exerciseStatus.isPlaying { return }
        playAudio(resource: "out_breath", ext: "mp3", targetDuration: duration)
    }

    func playChime() {
        if !exerciseStatus.isPlaying { return }

        playAudio(resource: "chime", ext: "mp3")
    }

    func isExerciseFinished(time: Double) -> Bool {
        return time >= breathExerciseTemplate.exerciseDuration
    }

    func finishExercise() {
        UIApplication.shared.isIdleTimerDisabled = false
        playChime()
        exerciseStatus = .finished

        // breathExercise always exists since we create it on start exercise
        if let breathExercise {
            do {
                try modelContext.transaction {
                    modelContext.delete(breathExercise)
                    breathExercise.completedAt = Date()
                    breathExercise.endedAt = Date()
                    modelContext.insert(breathExercise)
                }
            } catch {
                print("Failed to save exercise on finish \(error)")
            }
        }
    }

    func onViewUnmount() {
        exerciseStatus = .finished
        audioPlayer?.stop()
        UIApplication.shared.isIdleTimerDisabled = false

        if exerciseStatus == .finished || exerciseStatus == .not_started {
            return
        }

        if let breathExercise {
            do {
                try modelContext.transaction {
                    modelContext.delete(breathExercise)
                    breathExercise.endedAt = Date()
                    modelContext.insert(breathExercise)
                }
            } catch {
                print("Failed to save exercise on unmount \(error)")
            }
        }
    }

    var body: some View {
        NavigationStack {
            Text("Pattern \(String(format: "%.1f", breathExerciseTemplate.inBreathDuration)) - \(String(format: "%.1f", breathExerciseTemplate.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExerciseTemplate.outBreathDuration)) - \(String(format: "%.1f", breathExerciseTemplate.emptyHoldDuration))")
                .onDisappear {
                    onViewUnmount()
                }

            GeometryReader { geometry in
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
                        .frame(width: min(geometry.size.width * 0.75, 300),
                               height: min(geometry.size.width * 0.75, 300))
                        .onAppear {}

                    if exerciseStatus == .not_started {
                        Button(action: {
                            exerciseStatus = .inBreath
                            loopExerciseCycle()

                            breathExercise = BreathExercise(
                                createdAt: Date(),
                                startedAt: Date(),
                                completedAt: nil,
                                inBreathDuration: breathExerciseTemplate.inBreathDuration,
                                fullBreathHoldDuration: breathExerciseTemplate.fullBreathHoldDuration,
                                outBreathDuration: breathExerciseTemplate.outBreathDuration,
                                emptyHoldDuration: breathExerciseTemplate.emptyHoldDuration,
                                exerciseDuration: breathExerciseTemplate.exerciseDuration,
                                name: breathExerciseTemplate.name
                            )

                            if let breathExercise {
                                modelContext.insert(breathExercise)
                            }
                        }) {
                            Text("Start")
                                .font(.headline)
                                .cornerRadius(10)
                        }
                    }

                    if exerciseStatus == .finished {
                        Text("Finished")
                            .font(.headline)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .edgesIgnoringSafeArea(.all)

            HStack {
                TimerView(
                    timeElapsed: $timeElapsed,
                    isActive: .constant(exerciseStatus.isPlaying)
                )
                Text("/")
                TimerView(timeElapsed: .constant(breathExerciseTemplate.exerciseDuration), isActive: .constant(false))
            }.padding(.bottom, 16)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .toolbar {
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
        .onAppear(perform: onViewApper)
    }
}
