//
//  HomeView.swift
//  HeliStudy
//
//  Created by Huang XR on 18/11/25.
//

import SwiftUI

struct HomeCard: View {
    var title: String
    var content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.subheadline)
                .foregroundStyle(.myGray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
        .background(.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    HomeCard(title: "Tasks", content: "3 due today")
                    HomeCard(title: "Timer", content: "Start a session")
                    HomeCard(title: "Streaks", content: "🔥 12-day streak")
                    HomeCard(title: "Stats", content: "2h14m studied")
                    HomeCard(title: "Projects", content: "1 active")
                    HomeCard(title: "Calendar", content: "Next: Math revision")
                    
                }
                .padding()
            }
            .background(.BG)
        }
        .navigationTitle("Welcome!")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    HomeView()
}
