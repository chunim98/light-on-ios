//
//  LOButtonStyle.swift
//  LightOn
//
//  Created by 신정욱 on 5/24/25.
//

import UIKit

struct LOButtonStyle {
    
    // MARK: Properteis
    
    var strokeWidth: CGFloat = 0
    var strokeColor: UIColor?
    var backgroundColor: UIColor?
    var foregroundColor: UIColor?
    var disabledBackgroundColor: UIColor?
    var disabledForegroundColor: UIColor?
    var cornerStyle: UIButton.Configuration.CornerStyle = .fixed
    var cornerRadius: CGFloat = 6
    
    // MARK: Static Properties
    
    static var filled: LOButtonStyle {
        LOButtonStyle(
            backgroundColor: .brand,
            foregroundColor: .white,
            disabledBackgroundColor: .disable,
            disabledForegroundColor: .white
        )
    }
    
    static var bordered: LOButtonStyle {
        LOButtonStyle(
            strokeWidth: 1,
            strokeColor: .xCECECE,
            backgroundColor: .clear,
            foregroundColor: .loBlack
        )
    }
    
    static var borderedTinted: LOButtonStyle {
        LOButtonStyle(
            strokeWidth: 1,
            strokeColor: .brand,
            backgroundColor: .clear,
            foregroundColor: .brand
        )
    }
}

