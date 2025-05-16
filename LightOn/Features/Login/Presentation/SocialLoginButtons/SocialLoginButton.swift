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
    
    // MARK: Components
    
    private let tapGesture = UITapGestureRecognizer()
    
    // MARK: Life Cycle
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        addGestureRecognizer(tapGesture)
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.cornerRadius = size/2
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: size, height: size)
    }
}

// MARK: Publisher

extension SocialLoginButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        tapGesture.publisher().map{ _ in }.eraseToAnyPublisher()
    }
}

#Preview { SocialLoginButton(image: .loginSocialKakao) }

