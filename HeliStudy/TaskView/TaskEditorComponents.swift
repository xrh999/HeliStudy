//
//  TaskEditorComponents.swift
//  HeliStudy
//
//  Created by Huang XR on 7/6/26.
//

import SwiftUI

// TODO: make the textfield FocusState enum based

struct TaskPicker: View {
    @Binding var draft: DraftTask
    var body: some View {
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
}

struct MandatoryTaskItems: View {
    @Binding var draft: DraftTask
    @FocusState private var isKeyboardFocused: Bool
    var body: some View{
        Section(header: Text("Task info")) {
            TextField("Task Name", text: $draft.taskName)
                .focused($isKeyboardFocused)
            TextField("Description (optional)", text: $draft.taskDesc)
                .focused($isKeyboardFocused)
        }
    }
}

struct NewSRTaskView: View {
    @Binding var draft: DraftTask
    var body: some View {
        Section(header: Text("Times repeated")) {
            Stepper(value: $draft.repCnt, in: 0...Int.max) {
                Text("\(draft.repCnt)")
            }
        }
    }
}

struct NewRepeatedTaskView: View {
    let dateRange = Date.now...Date.distantFuture
    @Binding var draft: DraftTask
    @FocusState private var isKeyboardFocused: Bool
    var body: some View {
        
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

struct NewNormalTaskView: View {
    let dateRange = Date.now...Date.distantFuture
    @Binding var draft: DraftTask
    var body: some View {
        Section(header: Text("Schedule")) {
            DatePicker("Due date", selection: $draft.endDate, in: dateRange, displayedComponents: [.date, .hourAndMinute])
        }
    }
}

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
                    onSave()
                    showEditedAlert.toggle()
                }
                else {
                    onSave()
                    dismiss()
                }
            }
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(.borderedProminent)
    }
}
