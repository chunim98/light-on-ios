//
//  LoginOptionButtonsView.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

final class LoginOptionButtonsView: LODividerStackView {
    
    // MARK: Components
    
    private let registerButton = LoginOptionButton(title: "회원가입")
    private let findMyIDButton = LoginOptionButton(title: "아이디 찾기")
    private let findMyPWButton = LoginOptionButton(title: "비밀번호 찾기")
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = 18
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(registerButton)
        addArrangedSubview(findMyIDButton)
        addArrangedSubview(findMyPWButton)
    }
}

// MARK: Binders & Publishers

extension LoginOptionButtonsView {
    var registerTapPublisher: AnyPublisher<Void, Never> {
        registerButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
    
    var findMyIDTapPublisher: AnyPublisher<Void, Never> {
        findMyIDButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
    
    var findMyPWTapPublisher: AnyPublisher<Void, Never> {
        findMyPWButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LoginOptionButtonsView() }
