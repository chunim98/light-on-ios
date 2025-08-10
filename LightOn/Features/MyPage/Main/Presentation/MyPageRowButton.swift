//
//  MyPageRowButton.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit

final class MyPageRowButton: UIButton {
    
    // MARK: Properties
    
    private let title: String
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: super.intrinsicContentSize.width,
            height: 45
        )
    }
    
    // MARK: Life Cycle
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupDefaults()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.regular(16)
        titleConfig.foregroundColor = .loBlack
        titleConfig.lineHeight = 20
        titleConfig.text = title
        
        var config = Configuration.plain()
        config.attributedTitle = .init(config: titleConfig)
        config.imagePlacement = .trailing
        config.contentInsets = .zero
        config.image = .myPageArrow
        
        contentHorizontalAlignment = .fill
        configuration = config
    }
}
