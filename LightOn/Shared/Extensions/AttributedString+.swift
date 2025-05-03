//
//  AttributedString+.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

extension AttributedString {
    init(_ string: String, _ font: UIFont) {
        var container = AttributeContainer()
        container.font = font
        self.init(string, attributes: container)
    }
}
