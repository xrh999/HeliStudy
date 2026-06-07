//
//  CreateNewTask.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import SwiftUI
import Observation
import SwiftData
 
struct LeadingToolbarView: View {
    var mode: EditorMode
    @Binding var draft: DraftTask
    @Binding var confirmDeletion: Bool
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        switch mode {
            case .create:
                Button {
                    if (!draft.taskName.isEmpty) { confirmDeletion.toggle() }
                    else { dismiss() }
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
            case .edit:
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
       
    }
}
struct TrailingToolbarView: View {
    var mode: EditorMode
    @Binding var draft: DraftTask
    @Binding var showEmptyAlert: Bool
    @Binding var showEditedAlert: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            // TODO: Expand check to all fields
            if (draft.taskName.isEmpty) {
                showEmptyAlert = true
            } else {
                if case .edit = mode {
                    showEditedAlert.toggle()
                }
            }
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(.borderedProminent)
    }
}

struct TaskEditorView: View {
    let task: Task?
    var mode: EditorMode
    let dateRange = Date.now...Date.distantFuture
    @State private var draft: DraftTask
    @State private var confirmDeletion = false
    @State private var showEmptyAlert = false
    @State private var showEditedAlert = false
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
                ToolbarItem(placement: .topBarLeading) {
                    LeadingToolbarView(mode: mode, draft: $draft, confirmDeletion: $confirmDeletion)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    TrailingToolbarView(mode: mode, onSave: save(), draft: $draft, showEmptyAlert: $showEmptyAlert, showEditedAlert: $showEditedAlert)
                }
            }
            .confirmationDialog("Are you sure?", isPresented: $confirmDeletion) {
                Button("Kaboom", role: .destructive) {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Task saved!", isPresented: $showEditedAlert) {
                Button("Continue Editing") {
                    showEditedAlert.toggle()
                }
                Button {
                    showEditedAlert.toggle()
                    dismiss()
                } label: {
                    Text("Exit")
                        .foregroundStyle(.blue)
                }
            }
            .alert("Please fill it in", isPresented: $showEmptyAlert) {
                Button("Ok", role: .cancel) {showEmptyAlert = false}
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
    
    func save () {
        switch mode {
        case .create:
            switch draft.taskType {
            case .sr:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repCnt: draft.repCnt))
            case .repeated:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repeatInterval: draft.repeatInterval, endRepeat: draft.endRepeat, endDate: draft.endDate))
            case .normal:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, dueDate: draft.endDate))
            }
        case .edit:
            guard let task = task else {
                return
            }
            draft.apply(to: task)
        }
        try? context.save()
    }
}

struct LeadingToolbarView: View {
    var mode: EditorMode
    var onSave: () -> Void
    @Binding var draft: DraftTask
    @Binding var confirmDeletion: Bool
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        switch mode {
            case .create:
                Button {
                    if (!draft.taskName.isEmpty) { confirmDeletion.toggle() }
                    else { dismiss() }
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
            case .edit:
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
       
    }
}

struct TrailingToolbarView: View {
    var mode: EditorMode
    var onSave: () -> Void
    @Binding var draft: DraftTask
    @Binding var showEmptyAlert: Bool
    @Binding var showEditedAlert: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            // TODO: Expand check to all fields
            if (draft.taskName.isEmpty) {
                showEmptyAlert = true
            } else {
                if case .edit = mode {
                    showEditedAlert.toggle()
                }
                onSave()
            }
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    TaskEditorView(mode: .create)
}
