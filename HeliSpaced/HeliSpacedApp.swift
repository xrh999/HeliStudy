//
//  HeliSpacedApp.swift
//  HeliSpaced
//
//  Created by Huang XR on 28/5/26.
//

import SwiftUI
import SwiftData

@main
struct HeliSpacedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Entry.self)
    }
}
