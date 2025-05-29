//
//  SocialLoginButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

final class SocialLoginButton: UIImageView {
    
    // MARK: Properties
    
    private let size: CGFloat = 37
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: size, height: size)
    }
    
    // MARK: Components
    
    let tapGesture = UITapGestureRecognizer()
    
    // MARK: Life Cycle
    
    override init(image: UIImage?) {
        super.init(image: image)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        addGestureRecognizer(tapGesture)
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.cornerRadius = size/2
        layer.borderWidth = 1
        clipsToBounds = true
    }
}

// MARK: - Preview

#Preview { SocialLoginButton(image: .loginSocialKakao) }

