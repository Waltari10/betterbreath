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

    @State private var editMode: EditMode = .inactive
    @State private var isNavigating = false

    @Query private var breathExercises: [BreathExercise]

    @Query private var users: [User]
    var user: User? { users.first }

    private func createUser() {
        if user?.id == nil {
            let newUser = User()
            modelContext.insert(newUser)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if breathExercises.isEmpty {
                    Text("Add your first breath exercise from the top right plus button")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    // destination: BreathExerciseView(breathExercise: breathExercise)
                    ForEach(breathExercises) { breathExercise in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Breath exercise").bold()
                                Text("Duration: \(formatSeconds(seconds: breathExercise.exerciseDuration))")
                                Text("Pattern: \(String(format: "%.1f", breathExercise.inBreathDuration)) - \(String(format: "%.1f", breathExercise.fullBreathHoldDuration)) - \(String(format: "%.1f", breathExercise.outBreathDuration)) - \(String(format: "%.1f", breathExercise.emptyHoldDuration))")
                            }

                            Spacer()
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                                .foregroundColor(.gray)
                        }
                        .background(.white)
                        .navigationDestination(isPresented: $isNavigating) {
                            Text("FOO")
                            BreathExerciseView(breathExercise: breathExercise)
                        }
                        .onTapGesture(perform: {
                            print("foo")
                            isNavigating = true
                        })
                        .onLongPressGesture {
                            print("Long press")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            if editMode == .inactive {
                                editMode = .active
                            } else {
                                editMode = .inactive
                            }
                        }
                    }) {
                        if editMode == .inactive {
                            Image(systemName: "trash")
                                .imageScale(.large)
                                .font(.system(size: 16))
                        } else {
                            Text("Done")
                        }
                    }
                }

                ToolbarItem {
                    NavigationLink(destination: BreathExerciseSettingsView()) {
                        Label("Add breath exercise", systemImage: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .onAppear(perform: createUser)
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
