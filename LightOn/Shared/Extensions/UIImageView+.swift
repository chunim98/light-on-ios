//
//  UIImageView+.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

extension UIImageView {
    convenience init(contentMode: UIView.ContentMode) {
        self.init()
        self.contentMode = contentMode
    }
}
