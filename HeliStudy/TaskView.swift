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
    @Query private var Entries: [Entry]
    @State private var IsOpen = false
    var body: some View {
        NavigationStack {
            VStack {
                if Entries.isEmpty {
                    emptyState
                }
                else {
                    List(Entries) {
                        Text($0.name)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar{
                Button {
                    IsOpen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $IsOpen, onDismiss: {IsOpen = false}) {
            CreateNewTask { newTaskName, newTaskDesc, newCompleted in
                let newEntry = Entry(name: newTaskName, desc: newTaskDesc, repCnt: newCompleted)
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
        .modelContainer(for: Entry.self, inMemory: true)
}
