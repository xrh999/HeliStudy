//
//  Entry.swift
//  HeliStudy
//
//  Created by Huang XR on 29/5/26.
//

import Foundation
import SwiftData
var fib = [1, 1, 2, 3]

@Model
class SRTask: Equatable {
    var name: String
    var dateCreated: Date
    var desc: String?
    var repCnt: Int
    var nextDate: Date

    func reviewed() {
        if (repCnt >= fib.count) {
            while (fib.count <= repCnt) {
                fib.append(fib[fib.count - 1] + fib[fib.count - 2]);
            }
        }
        nextDate = Calendar.current.date(byAdding: .day, value: fib[repCnt], to: nextDate)!
        repCnt += 1
    }
    
    init (name: String, dateCreated: Date = Date(), desc: String? = nil, repCnt: Int = 0, nextDate: Date = Date()) {
        self.name = name
        self.dateCreated = dateCreated
        self.desc = desc
        self.repCnt = repCnt
        self.nextDate = nextDate
    }
}

@Model
class RTask: Equatable {
    var name: String
    var dateCreated: Date
    var desc: String?
    var repInterval: Int
    
    func reviewed() {
        dateCreated.addTimeInterval(TimeInterval(repInterval))
    }
    
    init (name: String, dateCreated: Date = Date(), desc: String? = nil, repInterval: Int) {
        self.name = name
        self.dateCreated = dateCreated
        self.desc = desc
        self.repInterval = repInterval
    }
}

@Model
class NormalTask: Equatable {
    var name: String
    var dateDue: Date
    var desc: String?
    
    init (name: String, dateDue: Date, desc: String? = nil) {
        self.name = name
        self.dateDue = dateDue
        self.desc = desc
    }
}
