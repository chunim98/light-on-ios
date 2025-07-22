//
//  UIView+.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import UIKit

extension UIView {
    var isHiddenWithAnime: Bool {
        get { self.isHidden }
        set {
            if newValue {
                // fade in
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 0
                } completion: { isFinished in
                    self.isHidden = isFinished
                }
            } else {
                // fade out
                self.alpha = 0
                self.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            }
        }
    }
}
