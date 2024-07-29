import SwiftUI

struct TimePickerModalView: View {
    @Binding var selectedTimeInSeconds: Double
    @Binding var title: String
    
    
    // initialise state to some placeholder vars that are replaced onAppear.
    @State private var minutesSelection: Int = 0
    @State private var secondsSelection: Int = 0
    @State private var deciSecondsSelection: Int = 0 // value of 1 here means 0.1 seconds
    
    // Hacky initializer. Custom init function was called multiple times for some reason.
    // First init call had wrong value for some reason.
    // There is probably a better way to do this.
    // This onAppear method seems to work however, but at the cost of extra render.
    
    private func onAppear() {
        
        // Calculate initial minutes and seconds from total seconds
        let totalSeconds = Int(selectedTimeInSeconds)
        
        minutesSelection = totalSeconds / 60
        secondsSelection = totalSeconds % 60
        
        
        // Avoid inherit bug where subtractions results in approx result
        let deciDiff =
        ((selectedTimeInSeconds - floor(selectedTimeInSeconds)) * 10).rounded() / 10
        
        let totalDeciseconds = Int(deciDiff * 10)
        
        deciSecondsSelection = totalDeciseconds
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
        .onAppear {
            onAppear()
        }
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
