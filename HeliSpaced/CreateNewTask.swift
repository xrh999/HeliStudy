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
    @State private var ShowAlert = false;
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
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        ShowAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            .alert(
                "Are you sure?",
                isPresented: $ShowAlert
            ) {
                Button(role: .destructive) {
                    ShowAlert = false
                    dismiss()
                } label: {
                    Text("Kaboom")
                }
                Button (role: .cancel) {
                    ShowAlert = false
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text("All changes will be unsaved")
            }
        }
        .padding(5)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    CreateNewTask()
}
