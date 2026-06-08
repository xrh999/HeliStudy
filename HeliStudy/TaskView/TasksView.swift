//
//  TaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 31/5/26.
//

import SwiftUI
import SwiftData

struct EmptyView: View {
    var body: some View {
        ContentUnavailableView(
            "No Tasks",
            systemImage: "checklist",
            description: Text("Tap + to add a new task")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TasksView: View {
    @State var mode: ViewMode
    @State private var now = Date()
    @State private var isOpen = false
    @State private var userQuery = ""
    @Namespace private var namespace
    @Query private var tasks: [Task]
    @Environment(\.modelContext) private var context

    var body: some View {
        let _ = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            now = Date()
        }
        var dueTasks: [Task] {
            tasks.filter { $0.nextDate <= now }
        }
        NavigationStack {
            VStack {
                if (mode == .today && dueTasks.isEmpty) || (mode == .all && tasks.isEmpty) {
                    EmptyView()
                }
                else {
                    let columns = [GridItem(.flexible(minimum: 190)), GridItem(.flexible(minimum: 190))]
                    LazyVGrid(columns: columns){
                        switch mode {
                        case .all:
                            ForEach(tasks) { task in
                                TaskCard(namespace: namespace, task: task)
                            }
                        case .today:
                            ForEach(dueTasks) { task in
                                TaskCard(namespace: namespace, task: task)
                            }

                        }
                    }
                }
            }
            .searchable(text: $userQuery)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Tasks")
            .toolbar{
                Button {
                    isOpen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding()
        }
        .sheet(isPresented: $isOpen, onDismiss: {isOpen = false}) {
            NavigationStack{
                TaskEditorView(mode: .create)
            }
        }
    }
}


#Preview {
    TasksView(mode: .today)
        .modelContainer(for: Task.self, inMemory: true)
}

