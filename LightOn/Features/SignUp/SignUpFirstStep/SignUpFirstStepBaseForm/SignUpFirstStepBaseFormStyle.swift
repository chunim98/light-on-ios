//
//  SignUpFirstStepBaseFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit

struct SignUpFirstStepBaseFormStyle {
    let titleColor: UIColor
    let borderColor: UIColor

    static var idle: Self { .init(titleColor: .caption, borderColor: .thumbLine) }
    static var focused: Self { .init(titleColor: .brand, borderColor: .brand) }
    static var filled: Self { .init(titleColor: .loBlack, borderColor: .loBlack) }
}
