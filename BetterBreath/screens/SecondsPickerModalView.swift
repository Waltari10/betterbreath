//
//  SecondsPickerModalView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 25.7.2024.
//

import SwiftUI

struct SecondsPickerModalView: View {
    @Binding var selectedDuration: Double
    @Binding var title: String
    var maxSeconds: Double
    var stepS: Double

    
    var durationOptions: [Double] {
         stride(from: 0.0, through: maxSeconds, by: stepS).map { $0 }
     }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            Picker(title, selection: $selectedDuration) {
                ForEach(durationOptions, id: \.self) { duration in
                    Text("\(duration, specifier: "%.1f") seconds").tag(duration)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            Button("Done") {
                // Dismiss the modal
                selectedDuration = selectedDuration
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
}

#Preview {
    SecondsPickerModalView(
        selectedDuration: .constant(5.0),
        title: .constant("Select In Breath Duration"),
        maxSeconds:10.0,
        stepS: 0.5
    )
}
