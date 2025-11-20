//
//  ToDoView.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var dueDate: Date
    var isDone: Bool
}

struct AddNewTask: View {
    @State private var taskName = ""
    @State private var taskDescription = ""
    @FocusState private var focus: FormFieldState?
    @State private var taskDueDate: Date = Date()
    @Environment(\.dismiss) private var dismiss

    // Callback to pass the new task back to the presenter
    var onSave: (Task) -> Void

    enum FormFieldState: Hashable {
        case name, desc
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task Info") {
                    TextField("Title", text: $taskName)
                        .focused($focus, equals: .name)
                        .onAppear { focus = .name }

                    TextField("Description", text: $taskDescription)
                        .focused($focus, equals: .desc)
                }

                Section("Due Date") {
                    DatePicker(
                        "Due Date",
                        selection: $taskDueDate,
                        in: Date()...
                    )
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    let trimmed = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
                    Button("Save") {
                        guard !trimmed.isEmpty else { return }
                        let newTask = Task(
                            name: trimmed,
                            description: taskDescription,
                            dueDate: taskDueDate,
                            isDone: false
                        )
                        onSave(newTask)
                        dismiss()
                    }
                    .disabled(trimmed.isEmpty)
                }
            }
        }
    }
}

struct ToDoView: View {
    @State private var tasks: [Task] = []
    @State private var isShowingNewTaskSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    ContentUnavailableView("No Tasks", systemImage: "checklist", description: Text("Tap + to add a new task"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                Button {
                                    toggleTask(task)
                                } label: {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isDone ? .green : .gray)
                                }
                                .buttonStyle(.plain)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(task.name)
                                        .strikethrough(task.isDone)
                                        .foregroundColor(task.isDone ? .secondary : .primary)
                                    if !task.description.isEmpty{
                                        Text(task.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text("Due: \(task.dueDate, style: .date)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteTask)
                    }
                }
            }
            .navigationTitle("To Do List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewTaskSheet = true
                    } label: {
                        Label("Add task", systemImage: "plus.circle")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewTaskSheet) {
            AddNewTask { newTask in
                addTask(newTask)
            }
            .presentationDetents([.medium, .large])
            .presentationBackground(.ultraThinMaterial)
        }
    }

    private func addTask(_ newTask: Task) {
        tasks.append(newTask)
    }

    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ToDoView()
}
