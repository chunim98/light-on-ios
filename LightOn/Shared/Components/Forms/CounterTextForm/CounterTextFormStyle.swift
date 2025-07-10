//
//  CounterTextFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit

struct CounterTextFormStyle {
    let titleColor: UIColor
    let borderColor: UIColor
    let byteColor: UIColor
    
    static var idle: Self {
        .init(
            titleColor: .caption,
            borderColor: .thumbLine,
            byteColor: .caption
        )
    }
    
    static var focused: Self {
        .init(
            titleColor: .brand,
            borderColor: .brand,
            byteColor: .caption
        )
    }
    
    static var filled: Self {
        .init(
            titleColor: .loBlack,
            borderColor: .loBlack,
            byteColor: .caption
        )
    }
    
    static var error: Self {
        .init(
            titleColor: .destructive,
            borderColor: .destructive,
            byteColor: .destructive
        )
    }
}
