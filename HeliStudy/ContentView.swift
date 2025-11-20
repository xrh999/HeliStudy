//
//  ContentView.swift
//  HeliStudy
//
//  Created by Huang XR on 4/8/25.
//

import SwiftUI

enum Tabs: Hashable {
    case timer
    case todo
    case leaderboard
    case settings
    case search
    case home
}

struct ContentView: View {
    @State private var selectedTab: Tabs = .home
    @State private var searchString = ""
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: Tabs.home) {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("Timer", systemImage: "timer", value: Tabs.timer) {
                PickTimerView()
            }
            Tab("Leaderboard", systemImage: "trophy", value: Tabs.leaderboard) {
                LeaderboardView()
            }
            // If you really want a Search tab, provide its content here.
            // For now, we can omit it or add a placeholder:
            Tab(value: Tabs.search, role: .search) {
                    ToDoView()
                        .searchable(text: $searchString)
            }
        }
        .accentColor(.accentColour)
    }
}

#Preview {
    ContentView()
}
