//
//  LOButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/24/25.
//

import UIKit

class LOButton: UIButton {
    
    // MARK: Properties
    
    let style: LOButtonStyle
    private var config = Configuration.filled()
    private let width: CGFloat?
    private let height: CGFloat
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: width ?? super.intrinsicContentSize.width,
            height: height
        )
    }
    
    // MARK: Life Cycle
    
    init(style: LOButtonStyle, width: CGFloat? = nil, height: CGFloat = 47) {
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
        config.baseBackgroundColor = style.backgroundColor
        config.background.strokeColor = style.strokeColor
        config.background.strokeWidth = style.strokeWidth
        config.background.cornerRadius = style.cornerRadius
        config.cornerStyle = style.cornerStyle
        configuration = config
    }
    
    // MARK: Public Configuration
    
    func setTitle(_ title: String, _ font: UIFont) {
        configurationUpdateHandler = { [weak self] in
            guard let self else { return }
            
            var titleConfig = TextConfiguration()
            titleConfig.text = title
            titleConfig.font = font
            
            var config = config // 복사해서 가지고 있어야 함
            
            if $0.isEnabled {
                config.baseBackgroundColor = style.backgroundColor
                config.baseForegroundColor = style.foregroundColor
                config.attributedTitle = .init(textConfig: titleConfig)
                
            } else {
                titleConfig.foregroundColor = style.disabledForegroundColor
                config.background.backgroundColor = style.disabledBackgroundColor
                config.attributedTitle = .init(textConfig: titleConfig)
            }
            
            $0.configuration = config
        }
    }
    
    func setIndicator(isLoading: Bool) {
        config.showsActivityIndicator = isLoading
        configuration = config
    }
}

// MARK: - Preview

#Preview {
    let button = LOButton(style: .filled)
    button.setTitle("로그인", .pretendard.bold(16))
//        button.isEnabled = false
    return button
}
