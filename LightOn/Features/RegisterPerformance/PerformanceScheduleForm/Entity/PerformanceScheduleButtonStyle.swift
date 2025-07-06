//
//  PerformanceScheduleButtonStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit

struct PerformanceScheduleButtonStyle {
    let strokeColor: UIColor
    let iconColor: UIColor
    let titleColor: UIColor
    let arrowColor: UIColor
    
    static var empty: PerformanceScheduleButtonStyle {
        PerformanceScheduleButtonStyle(
            strokeColor: .thumbLine,
            iconColor: .clickable,
            titleColor: .assistive,
            arrowColor: .assistive
        )
    }
    
    static var editing: PerformanceScheduleButtonStyle {
        PerformanceScheduleButtonStyle(
            strokeColor: .brand,
            iconColor: .clickable,
            titleColor: .assistive,
            arrowColor: .assistive
        )
    }
    
    static var filled: PerformanceScheduleButtonStyle {
        PerformanceScheduleButtonStyle(
            strokeColor: .loBlack,
            iconColor: .loBlack,
            titleColor: .loBlack,
            arrowColor: .loBlack
        )
    }
}
