//
//  AttributedString+.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

extension AttributedString {
    init?(textConfig config: TextConfiguration) {
        guard let attrStr = NSAttributedString(textConfig: config) else { return nil }
        self.init(attrStr)
    }
}
