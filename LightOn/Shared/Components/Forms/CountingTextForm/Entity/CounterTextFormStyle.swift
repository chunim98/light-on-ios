//
//  PerformanceNameFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import UIKit

struct CounterTextFormStyle {
    let titleColor: UIColor
    let fieldBorderColor: UIColor
    let byteColor: UIColor
    
    static var empty: CounterTextFormStyle {
        CounterTextFormStyle(
            titleColor: .caption,
            fieldBorderColor: .thumbLine,
            byteColor: .caption
        )
    }
    
    static var focused: CounterTextFormStyle {
        CounterTextFormStyle(
            titleColor: .brand,
            fieldBorderColor: .brand,
            byteColor: .caption
        )
    }
    
    static var filled: CounterTextFormStyle {
        CounterTextFormStyle(
            titleColor: .caption,
            fieldBorderColor: .loBlack,
            byteColor: .caption
        )
    }
    
    static var invalid: CounterTextFormStyle {
        CounterTextFormStyle(
            titleColor: .destructive,
            fieldBorderColor: .destructive,
            byteColor: .destructive
        )
    }
}
