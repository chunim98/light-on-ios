//
//  ScheduleFormButtonStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit

struct ScheduleFormButtonStyle {
    let strokeColor: UIColor
    let iconColor: UIColor
    let titleColor: UIColor
    let arrowColor: UIColor
    
    static var idle: ScheduleFormButtonStyle {
        ScheduleFormButtonStyle(
            strokeColor: .thumbLine,
            iconColor: .clickable,
            titleColor: .assistive,
            arrowColor: .assistive
        )
    }
    
    static var editing: ScheduleFormButtonStyle {
        ScheduleFormButtonStyle(
            strokeColor: .brand,
            iconColor: .clickable,
            titleColor: .assistive,
            arrowColor: .assistive
        )
    }
    
    static var filled: ScheduleFormButtonStyle {
        ScheduleFormButtonStyle(
            strokeColor: .loBlack,
            iconColor: .loBlack,
            titleColor: .loBlack,
            arrowColor: .loBlack
        )
    }
}
