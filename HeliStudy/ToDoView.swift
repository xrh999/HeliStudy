//
//  ToDoView.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI

struct Task: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var dueDate: Date
    var isDone: Bool

    init(id: UUID = UUID(), name: String, description: String, dueDate: Date, isDone: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.isDone = isDone
    }
}

struct AddNewTask: View {
    let mode: Int
    var task: Task?
    @State private var taskName = ""
    @State private var taskDescription = ""
    @FocusState private var focus: FormFieldState?
    @State private var taskDueDate: Date = Date()
    @Environment(\.dismiss) private var dismiss

    // Callback to pass the new/edited task back to the presenter
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
            .onAppear {
                if mode != 0, let task {
                    taskName = task.name
                    taskDescription = task.description
                    taskDueDate = task.dueDate
                }
            }
            .navigationTitle(mode == 0 ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmed = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        // Preserve id when editing
                        let newTask = Task(
                            id: task?.id ?? UUID(),
                            name: trimmed,
                            description: taskDescription,
                            dueDate: taskDueDate,
                            isDone: task?.isDone ?? false
                        )
                        onSave(newTask)
                        dismiss()
                    }
                    .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct ToDoView: View {
    @State private var taskBeingEdited: Task? = nil
    @State private var taskToDelete: Task? = nil
    @State private var tasks: [Task] = []
    @State private var isShowingNewTaskSheet = false
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }
            .navigationTitle("To Do List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        taskBeingEdited = nil
                        isShowingNewTaskSheet = true
                    } label: {
                        Label("Add task", systemImage: "plus.circle")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewTaskSheet) {
            AddNewTask(
                mode: taskBeingEdited == nil ? 0 : 1,
                task: taskBeingEdited,
                onSave: { newTask in
                    if let original = taskBeingEdited,
                       let index = tasks.firstIndex(where: { $0.id == original.id }) {
                        tasks[index] = newTask
                    } else {
                        addTask(newTask)
                    }
                    taskBeingEdited = nil
                }
            )
            .presentationDetents([.medium, .large])
            .presentationBackground(Material.ultraThinMaterial)
        }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        ContentUnavailableView(
            "No Tasks",
            systemImage: "checklist",
            description: Text("Tap + to add a new task")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.BG)
    }

    private var taskList: some View {
        List {
            ForEach(tasks) { task in
                taskRow(task)
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing) {
                        Button {
                            taskToDelete = task
                            showDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)

                        Button {
                            editButton(task)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
            .alert("Delete task?", isPresented: $showDeleteAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    deleteTask(taskToDelete)
                }
            }
        }
        .background(Color.BG)
    }

    @ViewBuilder
    private func taskRow(_ task: Task) -> some View {
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

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text("Due: \(task.dueDate, style: .date), \(task.dueDate, style: .time)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Actions

    private func addTask(_ newTask: Task) {
        tasks.append(newTask)
    }

    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    private func deleteTask(_ task: Task?) {
        guard let task else { return }
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }

    private func editButton(_ task: Task) {
        if tasks.contains(where: { $0.id == task.id }) {
            taskBeingEdited = task
            isShowingNewTaskSheet = true
        }
    }
}

#Preview {
    ToDoView()
}
