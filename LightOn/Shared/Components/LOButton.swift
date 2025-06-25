//
//  LOButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

final class LOButton: UIButton {
    
    // MARK: Enum
    
    enum Style {
        case filled
        case bordered
        case borderedTinted
    }

    // MARK: Properties
    
    private let style: Style
    private let height: CGFloat = 47
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    // MARK: Life Cycle
    
    init(style: LOButton.Style) {
        self.style = style
        super.init(frame: .zero)
        setupStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    
    private func setupStyle(_ style: LOButton.Style) {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        switch style {
        case .filled:
            config.baseBackgroundColor = .brand
            config.baseForegroundColor = .white
            
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
    
        configuration = config
    }
    
    // MARK: Public Configuration
    
    func setTitle(_ title: String, _ font: UIFont) {
        configuration?.attributedTitle = .init(title, font)
        
        // disable 상태이고, fill 스타일일 때만 비활성화 스타일 적용
        guard style == .filled else { return }
        configurationUpdateHandler = {
            guard !$0.isEnabled else { return }
            $0.configuration?.background.backgroundColor = .disable
            $0.configuration?.attributedTitle = .init(title, font, color: .white)
        }
    }
}

// MARK: - Preview

#Preview {
    let button = LOButton(style: .filled)
    button.setTitle("로그인", .pretendard.bold(16))
    return button
}
