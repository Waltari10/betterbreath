import Foundation
import SwiftData

// Template of a breath exercise

@Model
final class BreathExerciseTemplate {
    var createdAt: Date
    // Time in seconds
    var inBreathDuration: Double
    var fullBreathHoldDuration: Double
    var outBreathDuration: Double
    var emptyHoldDuration: Double
    // Total duration. How long exercise lasts in total
    // TODO: Maybe better to save # of breath cycles?
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
