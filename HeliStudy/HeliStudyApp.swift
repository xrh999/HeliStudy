//
//  HeliStudyApp.swift
//  HeliStudy
//
//  Created by Huang XR on 28/5/26.
//

import SwiftUI
import SwiftData

@main
struct HeliStudyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
