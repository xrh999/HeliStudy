//
//  Best_Study_AppApp.swift
//  Best Study App
//
//  Created by Huang XR on 4/8/25.
//

import SwiftUI
import Clerk

@main
struct Best_Study_AppApp: App {
    @State private var clerk = Clerk.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
