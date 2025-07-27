//
//  UIView+.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import UIKit

extension UIView {
    var isHiddenWithAnime: Bool {
        get { isHidden }
        set {
            guard isHidden != newValue else { return }  // 값이 동일하면 무시
            
            if newValue {
                // 숨기기 애니메이션
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 0
                } completion: { isFinished in
                    self.isHidden = isFinished
                }
                
            } else {
                // 보이기 애니메이션
                alpha = 0
                isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            }
        }
    }
}
