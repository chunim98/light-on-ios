//
//  TPButtonStyle.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/24/25.
//

import UIKit

struct TPButtonStyle {
    
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
    
    static var filled: TPButtonStyle {
        TPButtonStyle(
            backgroundColor: .brand,
            foregroundColor: .white,
            disabledBackgroundColor: .disable,
            disabledForegroundColor: .white
        )
    }
    
    static var bordered: TPButtonStyle {
        TPButtonStyle(
            strokeWidth: 1,
            strokeColor: .xCECECE,
            backgroundColor: .clear,
            foregroundColor: .blackLO
        )
    }
    
    static var borderedTinted: TPButtonStyle {
        TPButtonStyle(
            strokeWidth: 1,
            strokeColor: .brand,
            backgroundColor: .clear,
            foregroundColor: .brand
        )
    }
}

