//
//  LODividerStackView.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

class LODividerStackView: UIStackView {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Configuration
    
    override func addArrangedSubview(_ view: UIView) {
        let axis: LODivider.Axis = (self.axis == .horizontal) ? .vertical : .horizontal
        let divider = LODivider(axis: axis, width: 1, color: .disable)
        if !arrangedSubviews.isEmpty { super.addArrangedSubview(divider) }
        super.addArrangedSubview(view)
    }
        
    func addArrangedSubviewWithoutDivider(_ view: UIView) {
        super.addArrangedSubview(view)
    }
}
