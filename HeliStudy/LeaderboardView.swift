//
//  LeaderboardView.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI

struct LeaderboardView: View {
    @State var times: [Time] = []
    
    var body: some View {
        VStack {
            Spacer()
            // Podium for top 3
            if times.count >= 3 {
                HStack(alignment: .bottom, spacing: 20) {
                    // 2nd place (slightly lower than 1st)
                    if times.indices.contains(1) {
                        VStack {
                            Text(times[1].userID)
                                .font(.headline)
                            Text(formatTime(times[1].time))
                                .font(.subheadline)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 80, height: 120) // shorter platform
                                .overlay(Text("2").bold().foregroundColor(.white))
                        }
                    }
                    
                    // 1st place (tallest)
                    if times.indices.contains(0) {
                        VStack {
                            Text(times[0].userID)
                                .font(.title2).bold()
                            Text(formatTime(times[0].time))
                                .font(.subheadline)
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 80, height: 160) // tallest platform
                                .overlay(Text("1").bold().foregroundColor(.white))
                        }
                    }
                    
                    // 3rd place (shortest)
                    if times.indices.contains(2) {
                        VStack {
                            Text(times[2].userID)
                                .font(.headline)
                            Text(formatTime(times[2].time))
                                .font(.subheadline)
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: 80, height: 100) // shortest platform
                                .overlay(Text("3").bold().foregroundColor(.white))
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            List {
                ForEach(times.indices.dropFirst(3), id: \.self) { i in
                    HStack {
                        Text("#\(i + 1)")
                            .frame(width: 30, alignment: .leading)
                        Text(times[i].userID)
                        Spacer()
                        Text(formatTime(times[i].time))
                            .font(.subheadline)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listRowBackground(Color("cardBG"))
            Spacer()
            
        }
        .frame(maxHeight: .infinity)
        .background(.BG)
        .task {
            do {
                times = try await supabase
                    .from("timeTracked")
                    .select()
                    .order("time", ascending: false) // make sure it's sorted
                    .execute()
                    .value
            } catch {
                dump(error)
            }
        }
    }
    
    /// Converts minutes into "Xh Ym"
    func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(mins)m"
        }
    }
}

#Preview {
    LeaderboardView()
}

