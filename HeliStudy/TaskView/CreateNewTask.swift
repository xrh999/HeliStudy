//
//  CreateNewTask.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import SwiftUI
import SwiftData
 
struct CreateNewTask: View {
    var onSave: (Task) -> Void = { _ in }
    @State private var taskName = ""
    @State private var taskDesc = ""
    @State private var amtCompleted = 1
    @State private var confirmDeletion = false
    @State private var showEmptyAlert = false
    @State private var endRepeat = false
    @State private var repeatInterval = 1
    @State private var endDate = Date()
    @State private var selectedTaskType: TaskType = .repeated
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var isKeyboardFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Task info")) {
                        TextField("Task Name", text: $taskName)
                            .focused($isKeyboardFocused)
                        TextField("Description (optional)", text: $taskDesc)
                            .focused($isKeyboardFocused)
                    }
                    Section(header: Text("Task type")) {
                        Picker (selection: $selectedTaskType) {
                            Text("Spaced").tag(TaskType.sr)
                            Text("Repeated").tag(TaskType.repeated)
                            Text("Normal").tag(TaskType.normal)
                        } label: {
                            Text("")
                        }
                        .pickerStyle(.segmented)
                    }
                    switch selectedTaskType {
                    case .sr:
                        NewSRTaskView
                    case .repeated:
                        NewRepeatedTaskView
                    case .normal:
                        NewNormalTaskView
                    }
                }
                .onTapGesture {
                    isKeyboardFocused = false
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Group {
                        Button {
                            // TODO: Expand check to all fields
                            if (taskName.isEmpty) {
                                showEmptyAlert = true
                            } else {
                                let newTask: Task
                                switch selectedTaskType {
                                case .sr:
                                    newTask = Task(type: selectedTaskType, name: taskName, desc: taskDesc, repCnt: amtCompleted)
                                case .repeated:
                                    newTask = Task(type: selectedTaskType, name: taskName, desc: taskDesc, repeatInterval: repeatInterval, endRepeat: endRepeat, endDate: endDate)
                                case .normal:
                                    newTask = Task(type: selectedTaskType, name: taskName, desc: taskDesc, dueDate: endDate)
                                }
                                context.insert(newTask)
                                try? context.save()
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .alert("Please fill it in", isPresented: $showEmptyAlert) {
                        Button("Ok", role: .cancel) {showEmptyAlert = false}
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Group {
                        Button {
                            if (!taskName.isEmpty) { confirmDeletion = true }
                            else { dismiss() }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                    .alert(
                        "Are you sure?",
                        isPresented: $confirmDeletion
                    ) {
                        Button(role: .destructive) {
                            confirmDeletion = false
                            dismiss()
                        } label: {
                            Text("Kaboom")
                        }
                        Button(role: .cancel) {
                            confirmDeletion = false
                        } label: {
                            Text("Cancel")
                        }
                    } message: {
                        Text("All changes will be unsaved")
                    }
                }
            }
        }
        .padding(5)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private var NewSRTaskView: some View {
        Group {
            Section(header: Text("Times repeated")) {
                Stepper(value: $amtCompleted, in: 0...Int.max) {
                    Text("\(amtCompleted)")
                }
            }
        }
    }
    
    private var NewRepeatedTaskView: some View {
        Group {
            Section(header: Text("Repeat")) {
                Toggle(isOn: $endRepeat) {
                    Text("End repeat")
                }
                if (endRepeat) {
                    DatePicker("End date:", selection: $endDate, displayedComponents: .date)
                }
                TextField("Repeat interval (in days)", value: $repeatInterval, format: .number)
                    .keyboardType(.numberPad)
                    .focused($isKeyboardFocused)
            }
        }
    }
    
    private var NewNormalTaskView: some View {
        Group {
            Section(header: Text("Schedule")) {
                DatePicker("Due date", selection: $endDate, displayedComponents: .date)
            }
        }
    }
}
 
#Preview {
    CreateNewTask()
}
