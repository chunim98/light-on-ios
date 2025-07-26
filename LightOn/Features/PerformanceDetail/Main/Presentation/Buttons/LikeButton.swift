//
//  LikeButton.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

import SnapKit

final class LikeButton: UIButton {
    
    // MARK: Properties
    
    private var config = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .background
        config.background.strokeColor = .xDEDEDE
        config.background.strokeWidth = 1
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        config.contentInsets = .zero
        return config
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 48, height: 48)
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
        configurationUpdateHandler = { [weak self] in
            guard let self else { return }
            
            config.image = $0.isSelected ?
                .performanceDetailHeartFilled.withTintColor(.init(hex: 0xF4613C)) :
                .performanceDetailHeart
            
            $0.configuration = config
        }
        
        addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }

    // MARK: Event Handling
    
    @objc private func handleTapEvent() { self.isSelected.toggle() }
}

// MARK: - Preview

#Preview { LikeButton() }
