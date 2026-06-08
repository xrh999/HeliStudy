//
//  SelectTaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 8/6/26.
//

import SwiftUI

struct SelectTaskView: View {
    var body: some View {
        NavigationStack{
            List {
                NavigationLink {
                    TasksView(mode: .all)
                } label: {
                    Label("All tasks", systemImage: "rectangle.stack")
                }
                
                NavigationLink{
                    TasksView(mode: .today)
                } label: {
                    Label("Due Today", systemImage: "sun.min")
                }
            }
            .navigationTitle("Library")
        }
    }
}

#Preview {
    SelectTaskView()
}
