//
//  Item.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import Foundation
import SwiftData

@Model
final class BreathExercise {
    var createdAt: Date
    var inBreathDuration: Double
    var fullBreathHoldDuration: Double
    var outBreathDuration: Double
    var emptyHoldDuration: Double
    var name: String
    
    init(createdAt: Date,
         inBreathDuration: Double,
         fullBreathHoldDuration: Double,
         outBreathDuration: Double,
         emptyHoldDuration: Double,
         name: String
    ) {
        self.createdAt = createdAt
        self.inBreathDuration = inBreathDuration
        self.fullBreathHoldDuration = fullBreathHoldDuration
        self.outBreathDuration = outBreathDuration
        self.emptyHoldDuration = emptyHoldDuration
        self.name = name
        
    }
}
