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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var inBreathDuration: Double = 5.0
    @State private var fullBreathHoldDuration: Double = 0.0
    @State private var outBreathDuration: Double = 5.0
    @State private var emptyHoldDuration: Double = 0.0
    @State private var exerciseDuration: Double = 180.0
    @State private var pickerTitle: String = ""
    @State private var selectedPickerType: PickerType? = nil
    @State private var exerciseName: String = ""

    private let minValue: Double = 3.0
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
                VStack(alignment: .leading) {
                    TextField("Exercise name...", text: $exerciseName)
                        .padding()
                }
                .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("In breath \(String(format: "%.1f", $inBreathDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $inBreathDuration,
                        in: minValue ... maxValue,
                        step: step
                    )

                    Text("Hold \(String(format: "%.1f", $fullBreathHoldDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $fullBreathHoldDuration,
                        in: minValue ... maxValue,
                        step: step
                    )
                }
                .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("Out breath \(String(format: "%.1f", $outBreathDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $outBreathDuration,
                        in: minValue ... maxValue,
                        step: step
                    )

                    Text("Hold \(String(format: "%.1f", $emptyHoldDuration.wrappedValue)) s").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $emptyHoldDuration,
                        in: minValue ... maxValue,
                        step: step
                    )
                }
                .modifier(CardStyleModifier())

                VStack(alignment: .leading) {
                    Text("Duration \(timeFormatted($exerciseDuration.wrappedValue))").font(.title3)
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    Slider(
                        value: $exerciseDuration,
                        in: 60 ... 60 * 60,
                        step: 5
                    )
                }
                .modifier(CardStyleModifier())

                Spacer()
            }
            .padding(.bottom, 50) // Adds space at the bottom for scrolling when the keyboard is present
        }
        .ignoresSafeArea(.keyboard) // Prevents content from being pushed up by the keyboard

        Button(action: {
            saveExercise()
            dismiss()
        }) {
            Text("Save")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
        }
        .padding()
    }

    func saveExercise() {
        withAnimation {
            let newItem = BreathExercise(
                createdAt: Date(),
                inBreathDuration: inBreathDuration,
                fullBreathHoldDuration: fullBreathHoldDuration,
                outBreathDuration: outBreathDuration,
                emptyHoldDuration: emptyHoldDuration,
                exerciseDuration: exerciseDuration,
                name: exerciseName == "" ? "Breath exercise" : exerciseName
            )
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    BreathExerciseSettingsView()
}
