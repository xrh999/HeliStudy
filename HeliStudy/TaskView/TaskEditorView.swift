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
    @State private var draft: DraftTask
    @State private var confirmDeletion = false
    @State private var showEmptyAlert = false
    @State private var showEditedAlert = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
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
            "Edit Task"
        }
        Group {
            VStack(spacing: 0) {
                TaskPicker(draft: $draft)
                Form {
                    MandatoryTaskItems(draft: $draft)
                    switch draft.taskType {
                    case .sr:
                        NewSRTaskView(draft: $draft)
                    case .repeated:
                        NewRepeatedTaskView(draft: $draft)
                    case .normal:
                        NewNormalTaskView(draft: $draft)
                    }
                }
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    LeadingToolbarView(mode: mode, draft: $draft, confirmDeletion: $confirmDeletion)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    TrailingToolbarView(mode: mode, onSave: {
                        save()
                    }, draft: $draft, showEmptyAlert: $showEmptyAlert, showEditedAlert: $showEditedAlert)
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
                }
                .foregroundStyle(.blue)
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
    
    func save () {
        switch mode {
        case .create:
            switch draft.taskType {
            case .sr:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repCnt: draft.repCnt, endDate: Date()))
            case .repeated:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, repeatInterval: draft.repeatInterval, endRepeat: draft.endRepeat, endDate: draft.endDate))
            case .normal:
                context.insert(Task(type: draft.taskType, name: draft.taskName, desc: draft.taskDesc, endDate: draft.endDate))
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

#Preview {
    TaskEditorView(mode: .create)
}
