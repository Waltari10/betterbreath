//
//  BreathExerciseSettingsView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 25.7.2024.
//

import SwiftUI

struct BreathExerciseSettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    
    @State private var inBreathDuration: Double = 5.0
    @State private var fullBreathHoldDuration: Double = 0.0
    @State private var outBreathDuration: Double = 5.0
    @State private var emptyHoldDuration: Double = 0.0
    @State private var isEmptyHoldPickerPresented: Bool = false
    @State private var isPickerPresented: Bool = false
    @State private var pickerTitle: String = ""
    @State private var exerciseName: String = "New exercise"
    
    
    var body: some View {
        VStack {
            Button(action: {
                pickerTitle = "Select In Breath Duration"
                isPickerPresented = true;
            }) {
                Text("In Breath Duration: \(inBreathDuration, specifier: "%.1f") seconds")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isPickerPresented) {
                SecondsPickerModalView(
                    selectedDuration: $inBreathDuration,
                    title: $pickerTitle
                )
            }
            .padding()
            Button(action: {
                pickerTitle = "Select Full Breath Duration"
                isPickerPresented = true;
            }) {
                Text("Full Breath Duration: \(fullBreathHoldDuration, specifier: "%.1f") seconds")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            Button(action: {
                pickerTitle = "Select Out Breath Duration"
                isPickerPresented = true;
            }) {
                Text("Out Breath Duration: \(outBreathDuration, specifier: "%.1f") seconds")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            Button(action: {
                pickerTitle = "Select Empty Hold Breath Duration"
                isEmptyHoldPickerPresented = true;
            }) {
                Text("Empty hold Breath Duration: \(emptyHoldDuration, specifier: "%.1f") seconds")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isEmptyHoldPickerPresented) {
                SecondsPickerModalView(
                    selectedDuration: $emptyHoldDuration,
                    title: $pickerTitle
                )
            }
            .padding()
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
    
    func saveExercise() {
        // Code to start the exercise
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
