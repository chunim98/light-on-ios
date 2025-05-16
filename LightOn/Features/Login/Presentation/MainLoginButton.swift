//
//  MainLoginButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

final class MainLoginButton: UIStackView {
    
    // MARK: Components
    
    private let loginButton = {
        let button = LOButton(style: .filled)
        button.attributedTitle = .init("로그인", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inset = .init(horizontal: 18)
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setLayout() { addArrangedSubview(loginButton) }
}

// MARK: Publishers

extension MainLoginButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        loginButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    }
}

#Preview { MainLoginButton() }
