//
//  CreateNewTask.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import SwiftUI

struct CreateNewTask: View {
    var onSave: (String, String, Int) -> Void = { _,_,_ in }
    @State private var taskName = ""
    @State private var taskDesc = ""
    @State private var completed = 1;
    @State private var confirmDeletion = false;
    @State private var showEmptyAlert = false;
    @Environment(\.dismiss) private var dismiss
    enum TaskType {
        case sr, repeated, normal
    }
    @State private var selectedTask: TaskType = .sr
    
    var body: some View {
        NavigationStack {
            Group {
                Picker (selection: $selectedTask) {
                    Text("Spaced Repetition").tag(TaskType.sr)
                    Text("Repeating Task").tag(TaskType.repeated)
                    Text("To Do").tag(TaskType.normal)
                } label: {
                    Text("Just a test")
                }
                .pickerStyle(.segmented)
                switch selectedTask {
                case .sr: NewSRTaskView
                case .repeated: NewRepeatedTaskView
                case .normal: NewNormalTaskView
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Group {
                        Button {
                            if (taskName.isEmpty) {
                                showEmptyAlert = true
                            } else {
                                onSave(taskName, taskDesc, completed)
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
        Form {
            Section(header: Text("Task info")) {
                TextField(
                    "Task Name",
                    text: $taskName
                )
                TextField(
                    "Description (optional)",
                    text: $taskDesc
                )
            }
            Section(header: Text("Times repeated?")) {
                Stepper(value: $completed, in: 0...Int.max) {
                    Text("\(completed)")
                }
            }
        }
    }
    
    private var NewRepeatedTaskView: some View {
        Form {
            Section(header: Text("Task info")) {
                TextField(
                    "Task Name",
                    text: $taskName
                )
                TextField(
                    "Description (optional)",
                    text: $taskDesc
                )
            }
            Section(header: Text("Times repeated?")) {
                Stepper(value: $completed, in: 0...Int.max) {
                    Text("\(completed)")
                }
            }
        }
    }
    
    private var NewNormalTaskView: some View {
        Form {
            Section(header: Text("Task info")) {
                TextField(
                    "Task Name",
                    text: $taskName
                )
                TextField(
                    "Description (optional)",
                    text: $taskDesc
                )
            }
            Section(header: Text("Times repeated?")) {
                Stepper(value: $completed, in: 0...Int.max) {
                    Text("\(completed)")
                }
            }
        }
    }
}

#Preview {
    CreateNewTask()
}

