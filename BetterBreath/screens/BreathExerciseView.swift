//
//  BreathExerciseView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import SwiftUI

struct BreathExerciseView: View {
    
    var breathExercise: BreathExercise
    
    var body: some View {
        Text("breathExercise at \(breathExercise.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
    }
    
}



#Preview {
    BreathExerciseView(breathExercise: BreathExercise(
        createdAt: Date(),
        inBreathDuration: 5.0,
        fullBreathHoldDuration: 0.0,
        outBreathDuration: 0.0,
        emptyHoldDuration: 5.0,
        name: "Breath exercise"
    ))
        .modelContainer(for: BreathExercise.self, inMemory: true)
}

