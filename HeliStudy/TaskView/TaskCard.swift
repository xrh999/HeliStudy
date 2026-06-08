//
//  TaskCard.swift
//  HeliStudy
//
//  Created by Huang XR on 8/6/26.
//

import SwiftUI
import SwiftData

struct TaskCard: View {
    var namespace: Namespace.ID
    var task: Task
    @State var presentedTask = false
    @State private var showDeleteAlert = false
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        let icon = switch task.type {
        case .sr:
            "repeat.circle.fill"
        case .normal:
            "circle.fill"
        case .repeated:
            "star.fill"
        }
        Button {
            presentedTask.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(Color(task.colour).gradient)
                VStack {
                    Label("\(task.name)", systemImage: icon)
                        .fontWeight(.semibold)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                }
                .frame(height: 75, alignment: .top)
                .padding()
            }
            .contextMenu(menuItems: {
                Button {
                    presentedTask.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .tint(.blue)
                }
                Button {
                    showDeleteAlert.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .tint(.red)
                }
            })
            .alert("Delete task?", isPresented: $showDeleteAlert) {
                Button("Yes", role: .destructive) {
                    context.delete(task)
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .matchedTransitionSource(id: task.id, in: namespace)
        .fullScreenCover(isPresented: $presentedTask) {
            NavigationStack{
                // TODO: add in context menu with Edit, Delete, Rename, and Duplicate options
                TaskEditorView(mode: .edit, task: task)
            }
            .navigationTransition(.zoom(sourceID: task.id, in: namespace))
        }
    }
}
