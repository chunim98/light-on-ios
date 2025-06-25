//
//  LOPaddingLabel.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit

final class LOPaddingLabel: LOLabel {
    
    // MARK: Properties
    
    private var padding: UIEdgeInsets
    
    // MARK: Life Cycle

    init(configuration: TextConfiguration, padding: UIEdgeInsets = .zero) {
        self.padding = padding
        super.init(config: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
