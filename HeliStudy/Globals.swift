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
    var type: TaskType
    var name: String
    var desc: String?
    var dateCreated = Date()
    var colour: String
    
    // If it is spaced or repeated
    var nextDate: Date?
    
    // If it is spaced
    var repCnt: Int?
    
    // If it is repeated
    var repeatInterval: Int?
    var endRepeat: Bool?
    var endDate: Date?
    
    // If it is normal
    var dueDate: Date?
    var completed: Bool?
    
    // Spaced: type, name, desc, repCnt
    // Repeated: type, name, desc, repeatInterval, dueDate
    // Spaced: type, name, desc, dueDate,

    func reviewed() {
        switch type {
        case .sr:
            if (repCnt! >= fib.count) {
                while (fib.count <= repCnt!) {
                    fib.append(fib[fib.count - 1] + fib[fib.count - 2]);
                }
            }
            nextDate = Calendar.current.date(byAdding: .day, value: fib[repCnt!], to: nextDate!)
            repCnt! += 1
        case .repeated:
            dateCreated = dateCreated.addingTimeInterval(TimeInterval(repeatInterval!))
        case .normal:
            completed = true
        }
    }
    
    init (type: TaskType, name: String, desc: String?, dateCreated: Date = Date(), repCnt: Int? = nil, repeatInterval: Int? = nil, endRepeat: Bool? = nil, endDate: Date? = nil, dueDate: Date? = nil) {
        // TODO: Implement actual logic
        self.type = type
        self.name = name;
        self.desc = desc;
        self.dateCreated = dateCreated
        self.completed = false
        self.colour = CardColours.allCases.randomElement()!.colour
        switch type {
        case .normal:
            self.dueDate = dueDate
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
            dueDate = given.dueDate
            completed = given.completed ?? false
        } else {
            taskType = .sr
            taskName = ""
            taskDesc = ""
            repCnt = 1
            repeatInterval = 1
            endRepeat = false
            endDate = Date()
            dueDate = nil
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
        task.dueDate = nil
        task.completed = nil

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
            task.dueDate = dueDate
            task.completed = false
        }
    }
}

