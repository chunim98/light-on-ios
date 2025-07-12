//
//  ScheduleFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import Foundation

struct ScheduleFormState {
    let dateRange: (Date, Date)?
    let startTime: String?
    let endTime: String?
    
    let dateModalPresented: Bool
    let startTimeModalPresented: Bool
    let endTimeModalPresented: Bool
    
    let dateButtonsStyle: ScheduleFormButtonStyle
    let startTimeButtonStyle: ScheduleFormButtonStyle
    let endTimeButtonStyle: ScheduleFormButtonStyle
        
    func updated(
        dateRange: (Date, Date)?? = nil,
        startTime: String?? = nil,
        endTime: String?? = nil,
        dateModalPresented: Bool? = nil,
        startTimeModalPresented: Bool? = nil,
        endTimeModalPresented: Bool? = nil,
        dateButtonsStyle: ScheduleFormButtonStyle? = nil,
        startTimeButtonStyle: ScheduleFormButtonStyle? = nil,
        endTimeButtonStyle: ScheduleFormButtonStyle? = nil
    ) -> ScheduleFormState {
        ScheduleFormState(
            dateRange: dateRange ?? self.dateRange,
            startTime: startTime ?? self.startTime,
            endTime: endTime ?? self.endTime,
            dateModalPresented: dateModalPresented ?? self.dateModalPresented,
            startTimeModalPresented: startTimeModalPresented ?? self.startTimeModalPresented,
            endTimeModalPresented: endTimeModalPresented ?? self.endTimeModalPresented,
            dateButtonsStyle: dateButtonsStyle ?? self.dateButtonsStyle,
            startTimeButtonStyle: startTimeButtonStyle ?? self.startTimeButtonStyle,
            endTimeButtonStyle: endTimeButtonStyle ?? self.endTimeButtonStyle
        )
    }
}
