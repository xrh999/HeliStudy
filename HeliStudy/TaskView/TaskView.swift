//
//  TaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 31/5/26.
//

import SwiftUI
import SwiftData

struct TaskView: View {
    @Environment(\.modelContext) private var context
    @Query private var Tasks: [Task]
    @State private var isOpen = false
    var body: some View {
        NavigationStack {
            VStack {
                if Tasks.isEmpty {
                    emptyState
                }
                else {
                    List(Tasks) {
                        Text($0.name)
                        switch $0.type {
                        case .sr:
                            Text("Spaced Repetition")
                        case .repeated:
                            Text("Repeating Task")
                        case .normal:
                            Text("Normal Task")
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar{
                Button {
                    isOpen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isOpen, onDismiss: {isOpen = false}) {
            CreateNewTask { newTask in
                context.insert(newTask)
                try? context.save()
            }
        }
        .padding()
    }
    private var emptyState: some View {
        ContentUnavailableView(
            "No Tasks",
            systemImage: "checklist",
            description: Text("Tap + to add a new task")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    TaskView()
        .modelContainer(for: Task.self, inMemory: true)
}
