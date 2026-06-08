//
//  ContentView.swift
//  HeliStudy
//
//  Created by Huang XR on 28/5/26.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("To Do", systemImage: "checklist") {
                SelectTaskView()
            }
            Tab("Heatmap", systemImage: "calendar") {
                
            }
            Tab("Settings", systemImage: "gear") {
                
            }
        }
        .task {
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert])
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                }
            } catch {
                print("Failed to request notification authorization: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
