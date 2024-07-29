import SwiftUI

enum PickerType: String {
    case inBreath = "In Breath"
    case fullBreathHold = "Full Breath Hold"
    case outBreath = "Out Breath"
    case emptyHold = "Empty Hold Breath"
    case exerciseDuration = "Exercise Duration"
    
    var title: String {
        return self.rawValue
    }
}

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
    
    @State private var showPicker = false
    @State private var pickerTimeInSeconds: Double = 0.0
    
    var body: some View {
        List {
            durationButton(PickerType.inBreath.rawValue, duration: $inBreathDuration)
            durationButton(PickerType.fullBreathHold.rawValue, duration: $fullBreathHoldDuration)
            durationButton(PickerType.outBreath.rawValue, duration: $outBreathDuration)
            durationButton(PickerType.emptyHold.rawValue, duration: $emptyHoldDuration)
            durationButton(PickerType.exerciseDuration.rawValue, duration: $exerciseDuration)
        }
        .sheet(isPresented: $showPicker) {
            TimePickerModalView(
                selectedTimeInSeconds: $pickerTimeInSeconds,
                title: $pickerTitle
            ).onChange(of: pickerTimeInSeconds) { newValue in
                switch pickerTitle {
                case PickerType.inBreath.rawValue:
                    inBreathDuration = newValue
                case PickerType.fullBreathHold.rawValue:
                    fullBreathHoldDuration = newValue
                case PickerType.outBreath.rawValue:
                    outBreathDuration = newValue
                case PickerType.emptyHold.rawValue:
                    emptyHoldDuration = newValue
                case PickerType.exerciseDuration.rawValue:
                    exerciseDuration = newValue
                default:
                    break
                }
            }
        }
        
        Button(action: {
            saveExercise()
            dismiss()
        }) {
            Text("Save")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }.padding()
    }
    
    private func onPressSelectDuration(title: String, duration: Binding<Double>) {
        pickerTimeInSeconds = duration.wrappedValue
        pickerTitle = "\(title)"
        showPicker = true
    }
    
    private func durationButton(_ title: String, duration: Binding<Double>) -> some View {
        Button(
            action: {
                onPressSelectDuration(title: "\(title)", duration: duration)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(duration.wrappedValue, specifier: "%.1f") sec").bold()
                        Text("\(title)")
                    }
                    Spacer()
                    Image(systemName: "chevron.right") // Example system icon
                        .imageScale(.small)
                        .foregroundColor(.gray)
                }
            }
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
