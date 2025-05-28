//
//  TPButton.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/24/25.
//

import UIKit

class TPButton: UIButton {
    
    // MARK: Properties
    
    let style: TPButtonStyle
    private let width: CGFloat?
    private let height: CGFloat
    
    override var intrinsicContentSize: CGSize {
        if let width {
            CGSize(width: width, height: height)
        } else {
            CGSize(width: super.intrinsicContentSize.width, height: height)
        }
    }
    
    // MARK: Life Cycle
    
    init(style: TPButtonStyle, width: CGFloat? = nil, height: CGFloat = 47) {
        self.style = style
        self.width = width
        self.height = height
        super.init(frame: .zero)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    
    private func setupStyle() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = style.backgroundColor
        config.background.strokeColor = style.strokeColor
        config.background.strokeWidth = style.strokeWidth
        config.background.cornerRadius = style.cornerRadius
        config.cornerStyle = style.cornerStyle
        configuration = config
    }
    
    // MARK: Public Configuration
    
    func setTitle(_ title: String, _ font: UIFont) {
        configurationUpdateHandler = { [style] in
            var config = TextConfiguration()
            config.text = title
            config.font = font
            
            if $0.isEnabled {
                $0.configuration?.baseBackgroundColor = style.backgroundColor
                $0.configuration?.baseForegroundColor = style.foregroundColor
                $0.configuration?.attributedTitle = .init(textConfig: config)
                
            } else {
                config.foregroundColor = style.disabledForegroundColor
                $0.configuration?.background.backgroundColor = style.disabledBackgroundColor
                $0.configuration?.attributedTitle = .init(textConfig: config)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let button = TPButton(style: .filled)
    button.setTitle("로그인", .pretendard.bold(16))
//        button.isEnabled = false
    return button
}
