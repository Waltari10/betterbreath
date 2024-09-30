//
//  Router.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 13.9.2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case breathExerciseList
        case breathExercise(breathExercise: BreathExercise)
        case addBreathExercise
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
