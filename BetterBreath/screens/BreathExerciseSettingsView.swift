import SwiftUI

struct BreathExerciseSettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var inBreathDuration: Double = 5.0
    @State private var fullBreathHoldDuration: Double = 0.0
    @State private var outBreathDuration: Double = 5.0
    @State private var emptyHoldDuration: Double = 0.0
    @State private var pickerTitle: String = ""
    @State private var exerciseName: String = "New exercise"

    // Separate state for each picker presentation
    @State private var showInBreathPicker = false
    @State private var showFullBreathHoldPicker = false
    @State private var showOutBreathPicker = false
    @State private var showEmptyHoldPicker = false

    var body: some View {
        VStack {
            durationButton("In Breath Duration", duration: $inBreathDuration, showPicker: $showInBreathPicker)
            durationButton("Full Breath Hold Duration", duration: $fullBreathHoldDuration, showPicker: $showFullBreathHoldPicker)
            durationButton("Out Breath Duration", duration: $outBreathDuration, showPicker: $showOutBreathPicker)
            durationButton("Empty Hold Breath Duration", duration: $emptyHoldDuration, showPicker: $showEmptyHoldPicker)

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

    private func durationButton(_ title: String, duration: Binding<Double>, showPicker: Binding<Bool>) -> some View {
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
                title: $pickerTitle
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
                name: exerciseName
            )
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    BreathExerciseSettingsView()
}
