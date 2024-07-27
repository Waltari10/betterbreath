import SwiftUI

struct BreathExerciseSettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var inBreathDuration: Double = 5.0
    @State private var fullBreathHoldDuration: Double = 0.0
    @State private var outBreathDuration: Double = 5.0
    @State private var emptyHoldDuration: Double = 0.0
    @State private var exerciseDuration: Double = 60.0
    @State private var pickerTitle: String = ""
    @State private var exerciseName: String = "New exercise"

    // Separate state for each picker presentation
    @State private var showInBreathPicker = false
    @State private var showFullBreathHoldPicker = false
    @State private var showOutBreathPicker = false
    @State private var showEmptyHoldPicker = false
    @State private var showExerciseDurationPicker = false

    var body: some View {
        VStack {
            durationButton("In Breath Duration", duration: $inBreathDuration, showPicker: $showInBreathPicker, maxDurationS: 60.0, stepS: 0.5)
            durationButton("Full Breath Hold Duration", duration: $fullBreathHoldDuration, showPicker: $showFullBreathHoldPicker, maxDurationS : 60.0, stepS: 0.5)
            durationButton("Out Breath Duration", duration: $outBreathDuration, showPicker: $showOutBreathPicker, maxDurationS : 60.0, stepS: 0.5)
            durationButton("Empty Hold Breath Duration", duration: $emptyHoldDuration, showPicker: $showEmptyHoldPicker, maxDurationS : 60.0, stepS: 0.5)
            durationButton("Exercise Duration", duration: $exerciseDuration, showPicker: $showExerciseDurationPicker, maxDurationS : 3600.0, stepS: 30.0)

            Button(action: {
                saveExercise()
                dismiss()
            }) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.padding()
        }
    }

    private func durationButton(_ title: String, duration: Binding<Double>, showPicker: Binding<Bool>, maxDurationS: Double, stepS: Double) -> some View {
        Button(action: {
            pickerTitle = "Select \(title)"
            showPicker.wrappedValue = true
        }) {
            Text("\(title): \(duration.wrappedValue, specifier: "%.1f") seconds")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .sheet(isPresented: showPicker) {
            SecondsPickerModalView(
                selectedDuration: duration,
                title: $pickerTitle,
                maxSeconds: maxDurationS,
                stepS: stepS
            )
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
                name: exerciseName
            )
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    BreathExerciseSettingsView()
}
