//
//  IndivTaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 3/6/26.
//

import SwiftUI

struct TaskCardDetails: View {
    @Environment(\.dismiss) private var dismiss
    var task: Task
    var body: some View {
        NavigationStack{
            VStack {
                Form {
                    Section("Task Type") {
                        let text = switch task.type {
                        case .sr:
                            "Spaced Repetition"
                        case .normal:
                            "Normal Task"
                        case .repeated:
                            "Repeated Task"
                        }
                        Text("\(text)")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    TaskEditorView(mode: .view)
                }
            }
            .navigationTitle("\(task.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    TaskCardDetails(task: Task(type: .sr, name: "Test", desc: "What"))
}
