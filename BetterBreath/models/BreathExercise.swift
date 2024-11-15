//
//  BreathExercise.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import Foundation
import SwiftData

@Model
final class BreathExercise {
    var createdAt: Date
    // Time in seconds
    var inBreathDuration: Double
    var fullBreathHoldDuration: Double
    var outBreathDuration: Double
    var emptyHoldDuration: Double
    // Total duration. How long exercise lasts in total
    var exerciseDuration: Double
    var name: String

    init(createdAt: Date,
         inBreathDuration: Double,
         fullBreathHoldDuration: Double,
         outBreathDuration: Double,
         emptyHoldDuration: Double,
         exerciseDuration: Double,
         name: String)
    {
        self.createdAt = createdAt
        self.inBreathDuration = inBreathDuration
        self.fullBreathHoldDuration = fullBreathHoldDuration
        self.outBreathDuration = outBreathDuration
        self.emptyHoldDuration = emptyHoldDuration
        self.exerciseDuration = exerciseDuration
        self.name = name
    }
}
