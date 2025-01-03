import SwiftData
import SwiftUI

struct BreathExerciseListView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var editMode: EditMode = .inactive

    @Query private var breathExerciseTemplates: [BreathExerciseTemplate]

    @Query private var users: [User]
    var user: User? { users.first }

    private func createUser() {
        if user?.id == nil {
            let newUser = User()
            modelContext.insert(newUser)
        }
    }

    @State private var navigateToExercise = false
    @State private var navigateToEdit = false

    @State private var selectedExercise: BreathExerciseTemplate?
    @State private var editingExercise: BreathExerciseTemplate?

    var body: some View {
        NavigationStack {
            List {
                if breathExerciseTemplates.isEmpty {
                    Text("Add your first breath exercise from the top right plus button")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(breathExerciseTemplates) { template in
                        VStack {
                            NavigationLink(
                                destination: BreathExerciseView(breathExerciseTemplate: template),
                                tag: template,
                                selection: $selectedExercise
                            ) {
                                EmptyView()
                            }.hidden()

                            NavigationLink(
                                destination: BreathExerciseSettingsView(),
                                tag: template,
                                selection: $editingExercise
                            ) {
                                EmptyView()
                            }.hidden()

                            VStack(alignment: .leading) {
                                Text("\(template.name.description)")
                                Text("Duration: \(formatSeconds(seconds: template.exerciseDuration))")
                                Text("Pattern: \(String(format: "%.1f", template.inBreathDuration)) - \(String(format: "%.1f", template.fullBreathHoldDuration)) - \(String(format: "%.1f", template.outBreathDuration)) - \(String(format: "%.1f", template.emptyHoldDuration))")
                            }
                            .onTapGesture {
                                selectedExercise = template
                            }
                            .onLongPressGesture {
                                editingExercise = template
                            }
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
                modelContext.delete(breathExerciseTemplates[index])
            }
        }
    }
}

#Preview {
    BreathExerciseListView()
        .modelContainer(for: BreathExerciseTemplate.self, inMemory: true)
}
