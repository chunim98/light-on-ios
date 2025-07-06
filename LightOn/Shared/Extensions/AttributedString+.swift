//
//  AttributedString+.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

extension AttributedString {
    init?(config: AttrConfiguration) {
        guard let attrStr = NSAttributedString(config: config) else { return nil }
        self.init(attrStr)
    }
}
