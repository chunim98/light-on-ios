//
//  UIStackView+.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0,
        inset: NSDirectionalEdgeInsets? = nil
    ) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        
        if let inset {
            self.isLayoutMarginsRelativeArrangement = true
            self.directionalLayoutMargins = inset
        }
    }
    
    var inset: NSDirectionalEdgeInsets {
        get { self.directionalLayoutMargins }
        set {
            self.directionalLayoutMargins = newValue
            self.isLayoutMarginsRelativeArrangement = true
        }
    }
}
