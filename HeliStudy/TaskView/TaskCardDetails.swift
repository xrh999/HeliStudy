//
//  IndivTaskView.swift
//  HeliStudy
//
//  Created by Huang XR on 3/6/26.
//

import SwiftUI

struct TaskCardDetails: View {
    var task: Task
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    TaskCardDetails(task: Task(type: .sr, name: "Test", desc: "What"))
}
