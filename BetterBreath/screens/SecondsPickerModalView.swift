import SwiftUI

struct TimePickerModalView: View {
    @Binding var selectedTimeInSeconds: Double
    @Binding var title: String
    
    
    @State var minutesSelection: Int
    @State var secondsSelection: Int
    @State var deciSecondsSelection: Int // value of 1 here means 0.1 seconds
    
    // Custom initializer to compute minutes and seconds from total seconds
    init(selectedTimeInSeconds: Binding<Double>, title: Binding<String>) {
        self._selectedTimeInSeconds = selectedTimeInSeconds
        self._title = title
        // Calculate initial minutes and seconds from total seconds
        let totalSeconds = Int(selectedTimeInSeconds.wrappedValue)
        
        self._minutesSelection = State(initialValue: totalSeconds / 60)
        self._secondsSelection = State(initialValue: totalSeconds % 60)
        
        
        // Avoid inherit bug where subtractions results in approx result
        let deciDiff =
        ((selectedTimeInSeconds.wrappedValue - floor(selectedTimeInSeconds.wrappedValue)) * 10).rounded() / 10
        
        let totalDeciseconds = Int(deciDiff * 10)
        
        self._deciSecondsSelection = State(initialValue: totalDeciseconds)
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            // Minutes Picker
            HStack {
                VStack {
                    Text("Min")
                    Picker("Minutes", selection: $minutesSelection) {
                        ForEach(0..<60, id: \.self) { minute in
                            
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .onChange(of: minutesSelection, perform: { value in
                        
                        selectedTimeInSeconds = Double(minutesSelection * 60 + secondsSelection) + (Double(deciSecondsSelection) / 10)
                    })
                    .pickerStyle(WheelPickerStyle())
                }
                VStack {
                    Text("Sec")
                    // Seconds Picker
                    Picker("Seconds", selection: $secondsSelection) {
                        ForEach(0..<60, id: \.self) { second in
                            
                            Text(String(format: "%02d", second)).tag(second)
                        }
                    }
                    .onChange(of: secondsSelection, perform: { value in
                        
                        selectedTimeInSeconds = Double(minutesSelection * 60 + secondsSelection) + (Double(deciSecondsSelection) / 10)
                    })
                    .pickerStyle(WheelPickerStyle())
                }
                VStack {
                    Text("Decisec")
                    // Seconds Picker
                    Picker("Deciseconds", selection: $deciSecondsSelection) {
                        ForEach(0..<10, id: \.self) { deciSecond in
                            
                            Text(String(deciSecond)).tag(deciSecond)
                        }
                    }
                    .onChange(of: deciSecondsSelection, perform: { value in
                        
                        selectedTimeInSeconds = Double(minutesSelection * 60 + secondsSelection) + (Double(deciSecondsSelection) / 10)
                    })
                    .pickerStyle(WheelPickerStyle())
                }
            }
            Button("Done") {
                // Dismiss the modal
                presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    @Environment(\.presentationMode) var presentationMode
}

// Preview
struct TimePickerModalView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerModalView(
            selectedTimeInSeconds: .constant(301),
            title: .constant("Select Time")
        )
    }
}
