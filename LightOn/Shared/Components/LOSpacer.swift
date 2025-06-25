//
//  LOSpacer.swift
//  LightOn
//
//  Created by 신정욱 on 5/21/25.
//

import UIKit

final class LOSpacer: UIView {
    
    // MARK: Properties
    
    private let spacing: CGFloat?
    
    // MARK: Life Cycle
    
    init(_ spacing: CGFloat? = nil) {
        self.spacing = spacing
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Intrinsic Content Size

    override var intrinsicContentSize: CGSize {
        if let spacing {
            return CGSize(width: spacing, height: spacing)
        } else {
            return super.intrinsicContentSize
        }
    }
}
