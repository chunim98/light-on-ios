//
//  AddressFormButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/27/25.
//

import UIKit

final class AddressFormButton: UIButton {
    
    // MARK: Properties
    
    var titleConfig = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .assistive
        config.lineHeight = 23
        return config
    }() { didSet {
        configuration?.attributedTitle = .init(textConfig: titleConfig)
    } }
        
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 47)
    }

    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(horizontal: 18)
        config.baseBackgroundColor = .white
        config.imagePlacement = .trailing
        config.image = .signUpArrow
        
        config.background.strokeColor = .thumbLine
        config.background.strokeWidth = 1
        
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        configuration = config
        contentHorizontalAlignment = .fill
    }
}

// MARK: - Preview

#Preview { AddressFormButton() }
