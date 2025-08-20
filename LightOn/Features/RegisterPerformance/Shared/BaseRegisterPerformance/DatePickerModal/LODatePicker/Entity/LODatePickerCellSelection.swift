//
//  LODatePickerCellSelection.swift
//  LightOn
//
//  Created by 신정욱 on 8/20/25.
//

import Foundation

enum LODatePickerCellSelection {
    case `default`
    case single
    case start
    case end
    case inRange
    
    init(selectedDates: [Date], date: Date) {
        switch selectedDates.count {
        // 2개 선택된 경우
        case 2:
            let start = selectedDates[0]
            let end = selectedDates[1]
            
            if date == start {
                self = .start
            } else if date == end {
                self = .end
            } else if date > start && date < end {
                self = .inRange
            } else {
                self = .default
            }
            
        // 1개 선택된 경우
        case 1:
            let single = selectedDates[0]
            self = date == single ? .single : .default
            
        default:
            self = .default
        }
    }
}
