//
//  LODivider.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

final class LODivider: UIView {
    
    // MARK: Enum
    
    enum Axis {
        case vertical
        case horizontal
    }
    
    // MARK: Properties
    
    private let axis: Axis
    private let width: CGFloat
    
    // MARK: Life Cycle
    
    init(axis: Axis, width: CGFloat) {
        self.axis = axis
        self.width = width
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override Methods
    
    override var intrinsicContentSize: CGSize {
        axis == .horizontal ?
        CGSize(width: UIView.noIntrinsicMetric, height: width) :
        CGSize(width: width, height: UIView.noIntrinsicMetric)
    }
}
