//
//  NSAttributedString+.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

extension NSAttributedString {
    convenience init?(config: AttrConfiguration) {
        
        // MARK: Properties
        
        guard
            let text = config.text,
            let font = config.font
        else { return nil }
        
        let foregroundColor     = config.foregroundColor
        let paragraphSpacing    = config.paragraphSpacing
        let letterSpacing       = config.letterSpacing
        let lineHeight          = config.lineHeight
        let alignment           = config.alignment
        let underlineStyle      = config.underlineStyle
        let underlineColor      = config.underlineColor
        let lineBreakMode       = config.lineBreakMode
        
        let paragraphStyle = NSMutableParagraphStyle()
        var attrDic: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font
        ]
        
        // MARK: Setup Defaults
        
        paragraphSpacing.map    { paragraphStyle.paragraphSpacing = $0 }
        alignment.map           { paragraphStyle.alignment = $0 }
        lineBreakMode.map       { paragraphStyle.lineBreakMode = $0 }
        foregroundColor.map { attrDic[.foregroundColor] = $0 }
        underlineStyle.map  { attrDic[.underlineStyle] = $0.rawValue }
        underlineColor.map  { attrDic[.underlineColor] = $0 }
        letterSpacing.map   { attrDic[.kern] = font.pointSize * $0 }
        
        lineHeight.map {
            paragraphStyle.minimumLineHeight = $0   // 고정된 라인 높이
            paragraphStyle.maximumLineHeight = $0   // 고정된 라인 높이
            attrDic[.baselineOffset] = ($0-font.lineHeight) / 2
        }
        
        // MARK: Initializer
        
        self.init(string: text, attributes: attrDic)
    }
}
