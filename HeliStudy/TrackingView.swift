//
//  Tracking_View.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI
import AudioToolbox

struct TrackingView: View {
    let mode: Int
    let totalTime: Double
    let breakTime: Double
    let longBreakTime: Double
    let loopCount: Int

    @State private var timeRemaining: Double
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var hasStarted = false
    @State private var userResponded = false


    @State private var sessionIndex = 0
    @State private var isStudyPhase = true

    init(
        mode: Int,
        totalTime: Double,
        breakTime: Double? = nil,
        longBreakTime: Double? = nil,
        loopCount: Int? = nil
    ) {
        self.mode = mode
        self.totalTime = totalTime

        self.breakTime = breakTime ?? 300
        self.longBreakTime = longBreakTime ?? 900
        self.loopCount = loopCount ?? 4
        _timeRemaining = State(initialValue: totalTime)
    }

    var body: some View {
        VStack(spacing: 40) {
            if mode == 0 {
                countdownView(total: totalTime)
            } else if mode == 1 {
                pomodoroView
            }
        }
        .navigationTitle("Lock in!")
    }

    private func countdownView(total: Double) -> some View {
        VStack(spacing: 40) {
            timerCircle(total: total)

            HStack(spacing: 30) {
                Button(isRunning ? "Pause" : (hasStarted ? "Resume" : "Start")) {
                    if isRunning { pauseTimer() } else { startTimer() }
                }
                .buttonStyle(.borderedProminent)

                Button(userResponded ? "End and reset" : "Reset") {
                    resetTimer(total: total)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var pomodoroView: some View {
        VStack(spacing: 40) {
            timerCircle(total: currentPhaseLength)

            Text(isStudyPhase ? "Focus Session \(sessionIndex + 1)" : (isLongBreak ? "Long Break" : "Short Break"))
                .font(.headline)
                .padding(.top, -20)

            HStack(spacing: 30) {
                Button(isRunning ? "Pause" : (hasStarted ? "Resume" : "Start")) {
                    if isRunning { pauseTimer() } else { startTimer() }
                }
                .buttonStyle(.borderedProminent)

                Button("Reset Cycle") {
                    resetPomodoro()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func timerCircle(total: Double) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.2)
                .foregroundColor(.accentColour)

            Circle()
                .trim(from: 0, to: CGFloat(timeRemaining / total))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: timeRemaining)
                .frame(width: 300, height: 300)

            let hours = Int(timeRemaining) / 3600
            let minutes = (Int(timeRemaining) % 3600) / 60
            let seconds = Int(timeRemaining) % 60

            Text(
                (hours > 0 ? "\(hours) h " : "") +
                (minutes > 0 ? "\(minutes) min " : "") +
                (seconds > 0 ? "\(seconds) s" : "")
            )
            .font(.title2)
            .fontWeight(.semibold)
        }
        .frame(width: 300, height: 300)
    }

    private func startTimer() {
        if timeRemaining <= 0 {
            if mode == 0 {
                resetTimer(total: totalTime)
            } else {
                nextPomodoroPhase()
            }
        }
        isRunning = true
        hasStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
                AudioServicesPlaySystemSound(1013)
                if mode == 1 { nextPomodoroPhase() }
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    private func resetTimer(total: Double) {
        pauseTimer()
        timeRemaining = total
        hasStarted = false
        userResponded = true
    }

    private var isLongBreak: Bool {
        return !isStudyPhase && (sessionIndex + 1) % loopCount == 0
    }

    private var currentPhaseLength: Double {
        if isStudyPhase { return totalTime }
        return isLongBreak ? longBreakTime : breakTime
    }

    private func nextPomodoroPhase() {
        if isStudyPhase {
            isStudyPhase = false
        } else {
            sessionIndex += 1
            isStudyPhase = true
        }
        resetTimer(total: currentPhaseLength)
    }

    private func resetPomodoro() {
        pauseTimer()
        sessionIndex = 0
        isStudyPhase = true
        timeRemaining = totalTime
        hasStarted = false
        userResponded = true
    }
}

#Preview {
    TrackingView(mode: 1, totalTime: 1500, breakTime: Double(300), longBreakTime: Double(1200), loopCount: 3)
}
