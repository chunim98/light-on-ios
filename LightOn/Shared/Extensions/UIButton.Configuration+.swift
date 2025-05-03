//
//  UIButton.Configuration+.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

extension UIButton.Configuration {
    
    // MARK: enum
    
    enum LightOnStyle {
        case filled
        case bordered
        case borderedTinted
    }
    
    // MARK: Static Methods
    
    static func lightOn(_ style: LightOnStyle) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        switch style {
        case .filled:
            config.baseBackgroundColor = .brand
            config.baseForegroundColor = .white
            
        case .bordered:
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .black
            config.background.strokeColor = .lightGray
            config.background.strokeWidth = 1
            
        case .borderedTinted:
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .brand
            config.background.strokeColor = .brand
            config.background.strokeWidth = 1
        }
        
        return config
    }
}
