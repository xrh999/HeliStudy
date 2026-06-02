//
//  TaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 31/5/26.
//

import SwiftUI
import SwiftData

struct TaskCard: View {
    let task: Task
    var body: some View {
        let icon = switch task.type {
        case .sr:
            "repeat.circle.fill"
        case .normal:
            "circle.fill"
        case .repeated:
            "star.fill"
        }
        ZStack {
            // TODO: Add slight gradients to these colours
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color(task.colour))
            VStack {
                Label("\(task.name)", systemImage: icon)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(height: 75, alignment: .top)
            .padding()
        }
    }
}

struct TaskView: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [Task]
    @State private var isOpen = false
    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    emptyState
                }
                else {
                    let columns = [GridItem(.flexible(minimum: 190)), GridItem(.flexible(minimum: 190))]
                    LazyVGrid(columns: columns){
                        ForEach(tasks) { task in
                            TaskCard(task: task)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
            CreateNewTask()
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
