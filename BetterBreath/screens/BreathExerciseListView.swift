//
//  BreathExerciseListView.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 25.7.2024.
//

import SwiftData
import SwiftUI

struct BreathExerciseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var breathExercises: [BreathExercise]

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationSplitView {
            List {
                if breathExercises.isEmpty {
                    Text("Add your first breath exercise from the top right plus button")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(breathExercises) { breathExercise in
                        NavigationLink(destination: BreathExerciseView(breathExercise: breathExercise)) {
                            VStack(alignment: .leading) {
                                Text("Breath exercise").bold()
                                Text("Duration: \(formatSeconds(seconds: breathExercise.exerciseDuration))")
                                Text("Pattern: \(String(format: "%.1f", breathExercise.inBreathDuration)) - \(String(format: "%.1f", breathExercise.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExercise.outBreathDuration)) - \(String(format: "%.1f", breathExercise.emptyHoldDuration))")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            #endif
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                #endif
                ToolbarItem {
                    NavigationLink(destination: BreathExerciseSettingsView()) {
                        Label("Add breath exercise", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an breath exercise")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(breathExercises[index])
            }
        }
    }
}

#Preview {
    BreathExerciseListView()
        .modelContainer(for: BreathExercise.self, inMemory: true)
}
