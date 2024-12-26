import SwiftData
import SwiftUI

@main
struct BetterBreathApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            BreathExercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            var itemFetchDescriptor = FetchDescriptor<BreathExercise>()
            itemFetchDescriptor.fetchLimit = 1

            guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else {
                return container
            }

            let items = [
                BreathExercise(
                    createdAt: Date.now,
                    inBreathDuration: 4,
                    fullBreathHoldDuration: 4,
                    outBreathDuration: 4,
                    emptyHoldDuration: 4,
                    exerciseDuration: 176,
                    name: "Box"
                ),
                BreathExercise(
                    createdAt: Date.now,
                    inBreathDuration: 6,
                    fullBreathHoldDuration: 0,
                    outBreathDuration: 6,
                    emptyHoldDuration: 0,
                    exerciseDuration: 180,
                    name: "HRV"
                ),
            ]

            for item in items {
                container.mainContext.insert(item)
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            BreathExerciseListView()

        }.modelContainer(sharedModelContainer)
    }
}
