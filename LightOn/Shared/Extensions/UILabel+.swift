//
//  UILabel+.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit

extension UILabel {
    func setHighlightText(text: String, highlight: String, color: UIColor) {
        let range = (text as NSString).range(of: highlight)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.setAttributes([.foregroundColor: color], range: range)
        
        self.attributedText = attributedString
    }
}
