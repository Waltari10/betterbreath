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
    @State private var exerciseDuration: Double = 60.0
    @State private var pickerTitle: String = ""
    @State private var selectedPickerType: PickerType? = nil
    @State private var exerciseName: String = "New exercise"

    @State private var showPicker = false
    @State private var pickerTimeInSeconds: Double = 0.0

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("In breath").font(.title2)
                    .padding(.top, 4)
                    .padding(.bottom, 8)

                durationButton(pickerType: .inBreath, title: "In", modalTitle: "Breath in", duration: $inBreathDuration)

                Divider().padding(.vertical, 4).padding(.bottom, 8)

                durationButton(pickerType: .fullHold, title: "Hold", modalTitle: "Full hold", duration: $fullBreathHoldDuration)
            }.modifier(CardStyleModifier())

            VStack(alignment: .leading) {
                Text("Out breath").font(.title2).font(.title2)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                durationButton(pickerType: .outBreath, title: "Out", modalTitle: "Breath out", duration: $outBreathDuration)

                Divider().padding(.vertical, 4).padding(.bottom, 8)

                durationButton(pickerType: .emptyHold, title: "Hold", modalTitle: "Empty hold", duration: $emptyHoldDuration)
            }.modifier(CardStyleModifier())

            VStack(alignment: .leading) {
                Text("Duration").font(.title2).font(.title2)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                durationButton(pickerType: .exerciseDuration, title: nil, modalTitle: "Exercise duration", duration: $exerciseDuration)
                    .listRowSeparator(.hidden)
            }.modifier(CardStyleModifier())
                .sheet(isPresented: $showPicker) {
                    TimePickerModalView(
                        selectedTimeInSeconds: $pickerTimeInSeconds,
                        title: $pickerTitle
                    ).onChange(of: pickerTimeInSeconds) {
                        newValue in

                        switch selectedPickerType {
                        case .inBreath:
                            inBreathDuration = newValue
                        case .fullHold:
                            fullBreathHoldDuration = newValue
                        case .outBreath:
                            outBreathDuration = newValue
                        case .emptyHold:
                            emptyHoldDuration = newValue
                        case .exerciseDuration:
                            exerciseDuration = newValue
                        default:
                            break
                        }
                    }
                }
            Spacer()
        }.background(Color(.systemGray6))

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

    private func onPressSelectDuration(pickerType: PickerType, title: String, duration: Binding<Double>) {
        pickerTimeInSeconds = duration.wrappedValue
        pickerTitle = "\(title)"
        selectedPickerType = pickerType
        showPicker = true
    }

    private func durationButton(pickerType: PickerType, title: String? = nil, modalTitle: String, duration: Binding<Double>) -> some View {
        Button(
            action: {
                onPressSelectDuration(pickerType: pickerType, title: "\(modalTitle)", duration: duration)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(duration.wrappedValue, specifier: "%.1f") sec").bold()

                        if let unwrappedTitle = title {
                            Text(unwrappedTitle)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
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
