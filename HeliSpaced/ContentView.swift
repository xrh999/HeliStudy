//
//  ContentView.swift
//  HeliSpaced
//
//  Created by Huang XR on 28/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("To Do", systemImage: "checklist") {
                TaskView()
            }
            Tab("Heatmap", systemImage: "calendar") {
                
            }
            Tab("Settings", systemImage: "gear") {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
