//
//  Entry.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import Foundation
import SwiftData
var fib = [1, 1, 2, 3]

enum TaskType: Int, Codable {
    case sr = 0, repeated = 1, normal = 2
}

@Model
class Task: Equatable {
    var type: TaskType
    var name: String
    var desc: String?
    var dateCreated = Date()
    
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
            dateCreated.addTimeInterval(TimeInterval(repeatInterval!))
        case .normal:
            completed = true
        }
    }
    
    // FIXME: make init based off the TaskType
    init (type: TaskType, name: String, desc: String?, dateCreated: Date = Date(), nextDate: Date? = nil, repCnt: Int? = nil, repeatInterval: Int? = nil, endRepeat: Bool? = nil, endDate: Date? = nil, dueDate: Date? = nil, completed: Bool? = nil) {
        self.type = type
        self.name = name
        self.desc = desc
        self.dateCreated = dateCreated
        self.nextDate = nextDate
        self.repCnt = repCnt
        self.repeatInterval = repeatInterval
        self.endRepeat = endRepeat
        self.endDate = endDate
        self.dueDate = dueDate
        self.completed = completed
    }
}
