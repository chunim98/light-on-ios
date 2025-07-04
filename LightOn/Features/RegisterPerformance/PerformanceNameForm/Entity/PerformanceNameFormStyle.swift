//
//  PerformanceNameFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import UIKit

struct PerformanceNameFormStyle {
    let titleColor: UIColor
    let fieldBorderColor: UIColor
    let byteColor: UIColor
    
    static var empty: PerformanceNameFormStyle {
        PerformanceNameFormStyle(
            titleColor: .caption,
            fieldBorderColor: .thumbLine,
            byteColor: .caption
        )
    }
    
    static var focused: PerformanceNameFormStyle {
        PerformanceNameFormStyle(
            titleColor: .brand,
            fieldBorderColor: .brand,
            byteColor: .caption
        )
    }
    
    static var filled: PerformanceNameFormStyle {
        PerformanceNameFormStyle(
            titleColor: .caption,
            fieldBorderColor: .loBlack,
            byteColor: .caption
        )
    }
    
    static var invalid: PerformanceNameFormStyle {
        PerformanceNameFormStyle(
            titleColor: .destructive,
            fieldBorderColor: .destructive,
            byteColor: .destructive
        )
    }
}
