//
//  DateRange.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import Foundation

struct DateRange {
    let start: Date?
    let end: Date?
}

extension DateRange {
    init(start: String?, end: String?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.start = start.flatMap { formatter.date(from: $0) }
        self.end = end.flatMap { formatter.date(from: $0) }
    }
}
