import Foundation
import SwiftData

// Instance of a started and also maybe completed breath exercise.
// TODO: Should be created based on template whenever breath exercise is started.

@Model
final class BreathExercise {
    var createdAt: Date
    var startedAt: Date
    var endedAt: Date?
    var completedAt: Date?
    var inBreathDuration: Double
    var fullBreathHoldDuration: Double
    var outBreathDuration: Double
    var emptyHoldDuration: Double
    var exerciseDuration: Double
    var name: String

    init(
        createdAt: Date,
        startedAt: Date,
        completedAt: Date,
        endedAt: Date? = nil,
        inBreathDuration: Double,
        fullBreathHoldDuration: Double,
        outBreathDuration: Double,
        emptyHoldDuration: Double,
        exerciseDuration: Double,
        name: String
    ) {
        self.createdAt = createdAt
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.endedAt = endedAt
        self.inBreathDuration = inBreathDuration
        self.fullBreathHoldDuration = fullBreathHoldDuration
        self.outBreathDuration = outBreathDuration
        self.emptyHoldDuration = emptyHoldDuration
        self.exerciseDuration = exerciseDuration
        self.name = name
    }
}
