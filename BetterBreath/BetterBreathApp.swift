//
//  BetterBreathApp.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 25.7.2024.
//

import SwiftData
import SwiftUI

@main
struct BetterBreathApp: App {
    
    @ObservedObject var router = Router()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            BreathExercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            
            NavigationStack(path: $router.navPath) {
                BreathExerciseListView()
               .navigationDestination(for: Router.Destination.self) { destination in
                   switch destination {
                   case .addBreathExercise:
                       BreathExerciseSettingsView()
                   case .breathExercise(let breathExercise):
                       BreathExerciseView(breathExercise: BreathExercise)
                   }
               }
           }
           .environmentObject(router)

        }.modelContainer(sharedModelContainer)
    }
}
