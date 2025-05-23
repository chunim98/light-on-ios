//
//  SocialLoginButtonsView.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

final class SocialLoginButtonsView: UIStackView {
    
    // MARK: Components
    
    private let kakaoLoginButton = SocialLoginButton(image: .loginSocialKakao)
    private let googleLoginButton = SocialLoginButton(image: .loginSocialGoogle)
    private let appleLoginButton = SocialLoginButton(image: .loginSocialApple)
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = 10
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(kakaoLoginButton)
        addArrangedSubview(googleLoginButton)
        addArrangedSubview(appleLoginButton)
    }
}

// MARK: Binders & Publishers

extension SocialLoginButtonsView {
    var kakaoLoginTapPublisher: AnyPublisher<Void, Never> {
        kakaoLoginButton.tapPublisher
    }
    
    var googleLoginTapPublisher: AnyPublisher<Void, Never> {
        googleLoginButton.tapPublisher
    }
    
    var appleLoginTapPublisher: AnyPublisher<Void, Never> {
        appleLoginButton.tapPublisher
    }
}

// MARK: - Preview

#Preview { SocialLoginButtonsView() }
