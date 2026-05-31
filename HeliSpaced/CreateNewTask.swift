//
//  CreateNewTask.swift
//  HeliSpaced
//
//  Created by Huang XR on 29/5/26.
//

import SwiftUI

struct CreateNewTask: View {
    var onSave: (String, String, Int) -> Void = { _,_,_ in }
    @State private var TaskName = ""
    @State private var TaskDesc = ""
    @State private var Completed = 1;
    @State private var ConfirmDeletion = false;
    @State private var ShowEmptyAlert = false;
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Task info")) {
                    TextField(
                        "Task Name",
                        text: $TaskName
                    )
                    TextField(
                        "Description (optional)",
                        text : $TaskDesc
                    )
                }
                Section(header: Text("Times repeated?")) {
                    Stepper (value: $Completed) {
                        Text("\(Completed)")
                    }
                }
            }
            .navigationTitle("Add Spaced Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Group {
                        Button {
                            if (TaskName.isEmpty) {
                                ShowEmptyAlert = true
                            } else {
                                onSave(TaskName, TaskDesc, Completed)
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .alert("Please fill it in", isPresented: $ShowEmptyAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Group {
                        Button {
                            if (!TaskName.isEmpty) { ConfirmDeletion = true }
                            else { dismiss() }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                    .alert(
                        "Are you sure?",
                        isPresented: $ConfirmDeletion
                    ) {
                        Button(role: .destructive) {
                            ConfirmDeletion = false
                            dismiss()
                        } label: {
                            Text("Kaboom")
                        }
                        Button(role: .cancel) {
                            ConfirmDeletion = false
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
}

#Preview {
    CreateNewTask()
}
