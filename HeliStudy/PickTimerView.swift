//
//  Tracking_View.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI
import UIKit

struct CountdownPicker: UIViewRepresentable {
    @Binding var duration: TimeInterval  // seconds

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.countDownDuration = duration
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CountdownPicker
        init(_ parent: CountdownPicker) { self.parent = parent }

        @objc func valueChanged(_ sender: UIDatePicker) {
            parent.duration = sender.countDownDuration
        }
    }
}


struct PomodoroStepsView: View {
    @Binding var studyTime: Int
    @Binding var breakTime: Int
    @Binding var longBreakTime: Int
    @Binding var loopCount: Int
    @State private var showAlert = false
    @State private var showStudyTimePopover = false
    @State private var showBreakTimePopover = false
    @State private var showLoopCountPopover = false
    @State private var showLongBreakPopover = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)
                    Text("Decide on the task to be done.")
                        
                }

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "play.circle")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)
                    Text("Click the button below.")
                }

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "timer")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)

                    HStack(spacing: 0) {
                        Text("Work on the task for ")
                        Text("\(studyTime)")
                            .foregroundColor(.red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.red.opacity(0.1))
                            .cornerRadius(16)
                            .onTapGesture { showStudyTimePopover = true }
                            .popover(
                                isPresented: $showStudyTimePopover,
                                attachmentAnchor: .point(.top),
                                arrowEdge: .bottom
                            ) {
                                VStack(spacing: 8) {
                                    Picker("Select time", selection: $studyTime) {
                                        ForEach(1...90, id: \.self) { i in
                                            Text("\(i)").tag(i)
                                        }
                                    }
                                    .pickerStyle(.inline)
                                    .frame(maxHeight: 200)

                                    Button("Done") { showStudyTimePopover = false }
                                        .padding(.top, 4)
                                }
                                .frame(maxWidth:150, maxHeight: 400)
                                .presentationCompactAdaptation(.popover)
                                .padding()
                            }
                        Text(" minutes.")
                    }
                }

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "bell")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)
                    VStack(alignment: .leading) {
                        HStack(spacing: 0){
                            Text("End work for ")
                            Text("\(breakTime)")
                                .foregroundStyle(.red)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.red.opacity(0.1))
                                .cornerRadius(16)
                                .onTapGesture { showBreakTimePopover = true }
                                .popover(isPresented: $showBreakTimePopover, attachmentAnchor: .point(.top)) {
                                    VStack(spacing: 12) {
                                        Stepper {
                                            Text("Rest for \(breakTime) minutes")
                                        } onIncrement: {
                                            if breakTime < 50 { breakTime += 1 }
                                            else { showAlert = true }
                                        } onDecrement: {
                                            if breakTime > 1 { breakTime -= 1
                                                showAlert = false }
                                        }
                                        if showAlert {
                                            Text("A bit too long for a short break, don't you think?")
                                        }
                                        Button("Done") { showStudyTimePopover = false }
                                    }
                                    .presentationCompactAdaptation(.popover)
                                    .padding()
                                }
                            Text(" minutes when the")
                        }
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        Text("timer rings.")
                    }
                }

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "repeat")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)
                    VStack (alignment: .leading){
                        HStack(spacing: 0) {
                            Text("Repeat until ")
                            Text("\(loopCount)")
                                .foregroundStyle(.red)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.red.opacity(0.1))
                                .cornerRadius(16)
                                .onTapGesture { showLoopCountPopover = true }
                                .popover(isPresented: $showLoopCountPopover, attachmentAnchor: .point(.top)) {
                                    VStack(spacing: 12) {
                                        Stepper {
                                            Text("\(loopCount) times till long break")
                                        } onIncrement: {
                                            loopCount += 1
                                        } onDecrement: {
                                            if loopCount > 1 { loopCount -= 1 }
                                        }
                                        Button("Done") {
                                            showLoopCountPopover = false
                                        }
                                    }
                                    .presentationCompactAdaptation(.popover)
                                    .padding()
                                }
                            Text(" pomodori are")
                        }
                        .lineLimit(1)
                        Text("completed (plural for pomodoro).")
                    }
                }

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "sun.max")
                        .foregroundStyle(.accentColour)
                        .frame(width: 24)
                    VStack(alignment: .leading) {
                        Text("After that, take a long break for ")
                        HStack(spacing: 0) {
                            Text("\(longBreakTime)")
                                .foregroundStyle(.red)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.red.opacity(0.1))
                                .cornerRadius(16)
                                .onTapGesture { showLongBreakPopover = true }
                                .popover(isPresented: $showLongBreakPopover, attachmentAnchor: .point(.top)) {
                                    VStack(spacing: 8) {
                                        Picker("", selection: $longBreakTime) {
                                            ForEach(1...90, id: \.self) { i in
                                                Text("\(i)").tag(i)
                                            }
                                        }
                                        .pickerStyle(.inline)
                                        .frame(maxHeight: 200)
                                        Button("Done") {
                                            showLongBreakPopover = false
                                        }
                                        .padding(.top, 4)
                                    }
                                    .frame(maxWidth:150, maxHeight: 400)
                                    .presentationCompactAdaptation(.popover)
                                    .padding()
                                }
                            Text(" minutes.")
                        }
                    }
                }
            }
            .padding(24)
            .background(.regularMaterial)
            .cornerRadius(24)

        }
    }
}

struct PickTimerView: View {
    @State private var selection: String = "Pomodoro-style"
    @State var duration: Double = 60
    @State var step = ""
    @State var studyTime = 25
    @State var breakTime = 5
    @State var longBreakTime = 20
    @State var loopCount = 4

    let toppings: [String] = ["Normal", "Pomodoro-style"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Topping", selection: $selection) {
                    ForEach(toppings, id: \.self) { topping in
                        Text(topping.capitalized)
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                .navigationTitle("Timers")
                .navigationBarTitleDisplayMode(.large)

                if selection == "Normal" {
                    VStack(spacing: 16) {
                        Spacer()
                        CountdownPicker(duration: $duration)
                        Text("Duration: \(Int(duration/60)) min")
                        Spacer()
                    }
                } else if selection == "Pomodoro-style" {
                    Spacer()
                    PomodoroStepsView(
                        studyTime: $studyTime,
                        breakTime: $breakTime,
                        longBreakTime: $longBreakTime,
                        loopCount: $loopCount
                    )
                }
                Spacer()
                NavigationLink {
                    if selection == "Pomodoro-style" {
                        TrackingView(mode: 1, totalTime: Double(studyTime * 60), breakTime: Double(breakTime * 60), longBreakTime: Double(longBreakTime * 60), loopCount: loopCount)
                    }
                    else {
                        TrackingView(mode: 0, totalTime: Double(duration))
                    }
                } label: {
                    Text("Start Locking In!!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(.accentColour)
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                }
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    PickTimerView()
}
