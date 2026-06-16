//
//  Entry.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import Foundation
import SwiftData
import SwiftUI

var fib = [1, 1, 2, 3]

enum TaskType: Int, Codable {
    case sr = 0, repeated = 1, normal = 2
}

enum EditorMode {
    case edit, create
}

enum ViewMode {
    case all, today
}

enum CardColours: String, Codable, CaseIterable {
    case ashGrey,
    dessertSand,
    goldenSand,
    lavender,
    lightGreen,
    pearlAqua,
    richCerulean,
    softLinen
    
    var colour : String {
        rawValue
    }
}

@Model
class Task: Equatable {
    @Attribute(.unique) var id: UUID
    var type: TaskType
    var name: String
    var desc: String?
    var dateCreated = Date()
    var colour: String
    
    // If it is spaced or repeated
    var nextDate: Date
    
    // If it is spaced
    var repCnt: Int?
    
    // If it is repeated
    var repeatInterval: Int?
    var endRepeat: Bool?
    var endDate: Date?
    
    // If it is normal
    var completed = false
    
    // Spaced: type, name, desc, repCnt
    // Repeated: type, name, desc, repeatInterval, dueDate
    // Spaced: type, name, desc, dueDate,

    func reviewed() {
        switch type {
        case .sr:
            let index = repCnt ?? 0

            guard fib.count > index else { return }

            if index >= fib.count {
                while fib.count <= index {
                    fib.append(fib[fib.count - 1] + fib[fib.count - 2])
                }
            }

            nextDate = Calendar.current.date(
                byAdding: .day,
                value: fib[index],
                to: nextDate
            ) ?? nextDate

            repCnt = index + 1

        case .repeated:
            let interval = repeatInterval ?? 0
            nextDate = nextDate.addingTimeInterval(TimeInterval(interval))

            if let endDate, nextDate > endDate {
                completed = true
            }

        case .normal:
            completed = true
        }
    }
    init (type: TaskType, name: String, desc: String?, dateCreated: Date = Date(), repCnt: Int? = nil, repeatInterval: Int? = nil, endRepeat: Bool? = nil, endDate: Date? = nil) {
        self.id = UUID()
        self.type = type
        self.name = name;
        self.desc = desc;
        self.dateCreated = dateCreated
        self.completed = false
        self.colour = CardColours.allCases.randomElement()!.colour
        switch type {
        case .normal:
            self.nextDate = endDate ?? Date()
        case .repeated:
            self.endDate = endDate
            self.repeatInterval = repeatInterval
            self.repCnt = repCnt
            self.nextDate = Date()
        case .sr:
            self.nextDate = Date()
            self.repCnt = repCnt
        }
    }
}

@Model
class TagData {
    var tagName: String
    private var heatmap: [UInt64]
    
    init (tagName: String, size: Int) {
        self.tagName = tagName
        heatmap = Array(repeating: 0, count: (size + 63) / 64)
    }

    private func ensureCapacity(index: Int) {
        guard index >= 0 else { return }
        let requiredWords = (index / 64) + 1
        if heatmap.count < requiredWords {
            heatmap.append(contentsOf: repeatElement(0, count: requiredWords - heatmap.count))
        }
    }

    func get(index: Int) -> Bool {
        guard index >= 0 else { return false }
        let word = index / 64
        if word >= heatmap.count { return false }
        let bit = UInt64(1) << UInt64(index % 64)
        return (heatmap[word] & bit) != 0
    }

    func set(index: Int, value: Bool) {
        guard index >= 0 else { return }
        ensureCapacity(index: index)
        let word = index / 64
        let mask = UInt64(1) << UInt64(index % 64)
        if value {
            heatmap[word] |= mask
        } else {
            heatmap[word] &= ~mask
        }
    }

    @discardableResult
    func toggle(index: Int) -> Bool {
        guard index >= 0 else { return false }
        ensureCapacity(index: index)
        let word = index / 64
        let mask = UInt64(1) << UInt64(index % 64)
        heatmap[word] ^= mask
        return (heatmap[word] & mask) != 0
    }

    func resize(size: Int) {
        guard size >= 0 else { return }
        let words = (size + 63) / 64
        if words > heatmap.count {
            heatmap.append(contentsOf: repeatElement(0, count: words - heatmap.count))
        } else if words < heatmap.count {
            heatmap.removeLast(heatmap.count - words)
        }
        if size % 64 != 0, words > 0 {
            let validBits = (UInt64(1) << UInt64(size % 64)) - 1
            heatmap[words - 1] = heatmap[words - 1] & validBits
        }
    }

    func countSetBits() -> Int {
        heatmap.reduce(0) { $0 + $1.nonzeroBitCount }
    }

    func clear() {
        for i in heatmap.indices { heatmap[i] = 0 }
    }

}


@Observable
class DraftTask {
    var taskType: TaskType
    var taskName: String
    var taskDesc: String
    var repCnt: Int
    var repeatInterval: Int
    var endRepeat: Bool
    var endDate: Date
    var dueDate: Date? = nil
    var completed: Bool
    
    init(task: Task? = nil) {
        if let given = task {
            taskType = given.type
            taskName = given.name
            taskDesc = given.desc ?? ""
            repCnt = given.repCnt ?? 1
            repeatInterval = given.repeatInterval ?? 1
            endRepeat = given.endRepeat ?? false
            endDate = given.endDate ?? Date()
            completed = given.completed ?? false
        } else {
            taskType = .sr
            taskName = ""
            taskDesc = ""
            repCnt = 1
            repeatInterval = 1
            endRepeat = false
            endDate = Date()
            completed = false
        }
    }
    
    
    func apply(to task: Task) {
        task.type = taskType
        task.name = taskName
        task.desc = taskDesc.isEmpty ? nil : taskDesc

        task.repCnt = nil
        task.repeatInterval = nil
        task.endRepeat = nil
        task.endDate = nil

        switch taskType {
        case .sr:
            task.repCnt = repCnt
            task.nextDate = Date()

        case .repeated:
            task.repeatInterval = repeatInterval
            task.endRepeat = endRepeat
            task.endDate = endDate
            task.nextDate = Date()

        case .normal:
            task.endDate = endDate
            task.completed = completed
            task.nextDate = endDate ?? Date()
        }
    }
}

