//
//  AttributedString+.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

extension AttributedString {
    #warning("레거시 제거할것")
    init(_ string: String, _ font: UIFont?, color: UIColor? = nil) {
        var container = AttributeContainer()
        container.font = font
        container.foregroundColor = color
        self.init(string, attributes: container)
    }
    
    init?(textConfig config: TextConfiguration) {
        guard let attrStr = NSAttributedString(textConfig: config) else { return nil }
        self.init(attrStr)
    }
}
