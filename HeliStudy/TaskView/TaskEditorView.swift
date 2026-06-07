//
//  CreateNewTask.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import SwiftUI
import Observation
import SwiftData
 
struct TaskEditorView: View {
    let task: Task?
    var mode: EditorMode
    let dateRange = Date.now...Date.distantFuture
    @State private var draft: DraftTask
    @State private var confirmDeletion = false
    @State private var showEmptyAlert = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var isKeyboardFocused: Bool
    
    init(mode: EditorMode, task: Task? = nil) {
        self.task = task
        self.mode = mode
        _draft = State(initialValue: DraftTask(task: task))
    }
    
    var body: some View {
        let navTitle = switch mode {
        case .create:
            "Create Task"
        case .edit:
            "Edit \(draft.taskName)"
        }
        Group {
            VStack(spacing: 0) {
                TaskPicker
                Form {
                    MandatoryTaskItems
                    switch draft.taskType {
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
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Group {
                        Button {
                            // TODO: Expand check to all fields
                            if (draft.taskName.isEmpty) {
                                showEmptyAlert = true
                            } else {
                                Save()
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
                switch mode {
                case .create:
                    ToolbarItem(placement: .topBarLeading) {
                        Group {
                            Button {
                                if (!draft.taskName.isEmpty) { confirmDeletion = true }
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
                case .edit:
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
            }
            .padding(5)
            .background(
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
            )
        }
    }
    
    private var TaskPicker: some View {
        Picker (selection: $draft.taskType) {
            Text("Spaced").tag(TaskType.sr)
            Text("Repeated").tag(TaskType.repeated)
            Text("Normal").tag(TaskType.normal)
        } label: {
            Text("")
        }
        .pickerStyle(.segmented)
        .frame(width: 367)
        .padding(6)
    }
    
    private var MandatoryTaskItems: some View {
        Section(header: Text("Task info")) {
            TextField("Task Name", text: $draft.taskName)
                .focused($isKeyboardFocused)
            TextField("Description (optional)", text: $draft.taskDesc)
                .focused($isKeyboardFocused)
        }
    }

    private var NewSRTaskView: some View {
        Group {
            Section(header: Text("Times repeated")) {
                Stepper(value: $draft.repCnt, in: 0...Int.max) {
                    Text("\(draft.repCnt)")
                }
            }
        }
    }
    
    private var NewRepeatedTaskView: some View {
        Group {
            Section(header: Text("Repeat")) {
                Toggle(isOn: $draft.endRepeat) {
                    Text("End repeat")
                }
                if (draft.endRepeat) {
                    DatePicker("End date:", selection: $draft.endDate, in: dateRange, displayedComponents: .date)
                }
                TextField("Repeat interval (in days)", value: $draft.repeatInterval, format: .number)
                    .keyboardType(.numberPad)
                    .focused($isKeyboardFocused)
            }
        }
    }
    
    private var NewNormalTaskView: some View {
        Group {
            Section(header: Text("Schedule")) {
                DatePicker("Due date", selection: $draft.endDate, in: dateRange, displayedComponents: [.date, .hourAndMinute])
            }
        }
    }
    
    private func Save () {
        // TODO: Add in code for saving a task
        let newTask: Task
        switch draft.taskType {
        case .sr:
            newTask = Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repCnt: draft.repCnt)
        case .repeated:
            newTask = Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repeatInterval: draft.repeatInterval, endRepeat: draft.endRepeat, endDate: draft.endDate)
        case .normal:
            newTask = Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, dueDate: draft.endDate)
        }
        context.insert(newTask)
        try? context.save()
        dismiss()
    }
    
}
 
#Preview {
    TaskEditorView(mode: .create)
}
