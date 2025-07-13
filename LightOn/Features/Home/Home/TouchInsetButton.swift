//
//  TouchInsetButton.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit

class TouchInsetButton: UIButton {
    
    // MARK: Properties
    
    /// 버튼 터치영역 인셋
    var touchAreaInset = UIEdgeInsets(edges: 8)
    
    // MARK: Overrides
    
    override func point(
        inside point: CGPoint,
        with event: UIEvent?
    ) -> Bool {
        super.point(inside: point, with: event)
        let touchArea = bounds.inset(by: UIEdgeInsets(
            top:    -touchAreaInset.top,
            left:   -touchAreaInset.left,
            bottom: -touchAreaInset.bottom,
            right:  -touchAreaInset.right
        ))
        return touchArea.contains(point)
    }
}
