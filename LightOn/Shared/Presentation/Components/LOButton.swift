//
//  LOButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

final class LOButton: UIButton {
    
    // MARK: enum
    
    enum Style {
        case filled
        case bordered
        case borderedTinted
    }

    // MARK: Properties
    
    private let height: CGFloat = 47
    
    // MARK: Life Cycle
    
    init(style: LOButton.Style) {
        super.init(frame: .zero)
        setupDefaults(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: height)
    }
    
    // MARK: Configuration
    
    private func setupDefaults(_ style: LOButton.Style) {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("버튼", .systemFont(ofSize: 16))
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        switch style {
        case .filled:
            config.baseBackgroundColor = .brand
            config.baseForegroundColor = .loWhite
            
        case .bordered:
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .loBlack
            config.background.strokeColor = UIColor(hex: 0xCECECE)
            config.background.strokeWidth = 1
            
        case .borderedTinted:
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .brand
            config.background.strokeColor = .brand
            config.background.strokeWidth = 1
        }
        
        self.configuration = config
    }
    
    var attributedTitle: AttributedString? {
        get { self.configuration?.attributedTitle }
        set { self.configuration?.attributedTitle = newValue }
    }
}

#Preview { LOButton(style: .filled) }
