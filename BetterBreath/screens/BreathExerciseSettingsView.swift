import SwiftUI

enum PickerType: String {
    case inBreath
    case fullHold
    case outBreath
    case emptyHold
    case exerciseDuration

    var title: String {
        return rawValue
    }
}

struct BreathExerciseSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var exerciseCycles: Double = 10.0 // could be int, but double for simplicity
    @State private var inBreathDuration: Double = 5.0
    @State private var fullBreathHoldDuration: Double = 0.0
    @State private var outBreathDuration: Double = 5.0
    @State private var emptyHoldDuration: Double = 0.0
    @State private var pickerTitle: String = ""
    @State private var selectedPickerType: PickerType? = nil
    @State private var exerciseName: String = ""

    private let minValueBreath: Double = 2.0
    private let minValueHold: Double = 0.0
    private let maxValue: Double = 60.0
    private let step: Double = 0.5

    func timeFormatted(_ totalSeconds: Double) -> String {
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("Exercise name...", text: $exerciseName)
                    .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("In breath: \(String(format: "%.1f", $inBreathDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $inBreathDuration,
                        in: minValueBreath ... maxValue,
                        step: step
                    )

                    Text("Hold: \(String(format: "%.1f", $fullBreathHoldDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $fullBreathHoldDuration,
                        in: minValueHold ... maxValue,
                        step: step
                    )
                }
                .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("Out breath: \(String(format: "%.1f", $outBreathDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $outBreathDuration,
                        in: minValueBreath ... maxValue,
                        step: step
                    )

                    Text("Hold: \(String(format: "%.1f", $emptyHoldDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $emptyHoldDuration,
                        in: minValueHold ... maxValue,
                        step: step
                    )
                }
                .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("Cycles: \(String(format: "%.0f", $exerciseCycles.wrappedValue))").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 4)

                    Text("Duration: \(formatSeconds(seconds: exerciseCycles * (inBreathDuration + fullBreathHoldDuration + outBreathDuration + emptyHoldDuration)))").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $exerciseCycles,
                        in: 1 ... 500,
                        step: 1
                    )
                }
                .modifier(CardStyleModifier())

                Spacer()
            }
            .padding(.bottom, 50)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .ignoresSafeArea(.keyboard)

        Button(action: {
            saveExercise()
            dismiss()
        }) {
            Text("Save")
                .font(.headline)
                .cornerRadius(10)
        }
    }

    func saveExercise() {
        withAnimation {
            let newItem = BreathExerciseTemplate(
                createdAt: Date(),
                inBreathDuration: inBreathDuration,
                fullBreathHoldDuration: fullBreathHoldDuration,
                outBreathDuration: outBreathDuration,
                emptyHoldDuration: emptyHoldDuration,
                exerciseDuration: Double(exerciseCycles) * (inBreathDuration + fullBreathHoldDuration + outBreathDuration + emptyHoldDuration),
                name: exerciseName == "" ? "Breath exercise" : exerciseName
            )
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    BreathExerciseSettingsView()
}
