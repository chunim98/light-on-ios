//
//  ScheduleFormTitleStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit

struct ScheduleFormTitleStyle {
    let titleColor: UIColor
    
    static var idle: ScheduleFormTitleStyle {
        .init(titleColor: .caption)
    }
    
    static var editing: ScheduleFormTitleStyle {
        .init(titleColor: .brand)
    }
    
    static var filled: ScheduleFormTitleStyle {
        .init(titleColor: .caption)
    }
}
