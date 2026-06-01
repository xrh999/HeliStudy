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
    @State private var completed = 1
    @State private var confirmDeletion = false
    @State private var showEmptyAlert = false
    @State private var endRepeat = false
    @State private var repeatDays: Int? = nil
    @State private var endDate = Date()
    @FocusState private var isKeyboardFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTask: TaskType = .repeated
    
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
                        Picker (selection: $selectedTask) {
                            Text("Spaced").tag(TaskType.sr)
                            Text("Repeated").tag(TaskType.repeated)
                            Text("Normal").tag(TaskType.normal)
                        } label: {
                            Text("")
                        }
                        .pickerStyle(.segmented)
                    }
                    switch selectedTask {
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
        Group {
            Section(header: Text("Times repeated")) {
                Stepper(value: $completed, in: 0...Int.max) {
                    Text("\(completed)")
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
                TextField("Repeat interval (in days)", value: $repeatDays, format: .number)
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
