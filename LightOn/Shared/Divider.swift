//
//  Divider.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit

final class Divider: UIView {
    
    // MARK: Properties
    
    private let width: CGFloat?
    private let height: CGFloat?
    
    // MARK: Components
    
    
    // MARK: Life Cycle
    
    init(width: CGFloat? = nil, height: CGFloat? = nil, color: UIColor) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
        backgroundColor = color
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: width ?? super.intrinsicContentSize.width,
            height: height ?? super.intrinsicContentSize.height
        )
    }
}
