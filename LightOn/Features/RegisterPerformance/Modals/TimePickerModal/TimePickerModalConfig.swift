//
//  TimePickerModalConfig.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

struct TimePickerModalConfig {
    let title: String
    
    static var start: TimePickerModalConfig {
        .init(title: "공연 시작 시간")
    }
    
    static var end: TimePickerModalConfig {
        .init(title: "공연 종료 시간")
    }
}
