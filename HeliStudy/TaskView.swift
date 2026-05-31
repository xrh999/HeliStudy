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
    @Query private var SRTasks: [SRTask]
    @State private var isOpen = false
    var body: some View {
        NavigationStack {
            VStack {
                if SRTasks.isEmpty {
                    emptyState
                }
                else {
                    List(SRTasks) {
                        Text($0.name)
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
            CreateNewTask { newTaskName, newTaskDesc, newCompleted in
                let newEntry = SRTask(name: newTaskName, desc: newTaskDesc, repCnt: newCompleted)
                context.insert(newEntry)
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
        .modelContainer(for: SRTask.self, inMemory: true)
}
