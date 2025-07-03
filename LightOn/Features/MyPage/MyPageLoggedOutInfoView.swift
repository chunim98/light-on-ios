//
//  MyPageLoggedOutInfoView.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit

import SnapKit

final class MyPageLoggedOutInfoView: UIStackView {
    
    // MARK: Components
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let descriptionLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .loBlack
        config.paragraphSpacing = 8
        config.lineHeight = 16
        config.text = "로그인 상태가 아닙니다.\n로그인/회원가입 후 이용해주세요."
        let label = LOLabel(config: config)
        label.addAnyAttribute(
            name: .font,
            value: UIFont.pretendard.semiBold(16)!,
            segment: "로그인/회원가입 후 이용해주세요."
        )
        label.numberOfLines = 2
        return label
    }()
    
    let loginButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("로그인", .pretendard.semiBold(16))
        return button
    }()
    
    let signUpButton = {
        let button = LOButton(style: .filled)
        button.setTitle("회원가입", .pretendard.semiBold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18, vertical: 30)
        backgroundColor = .xF5F0FF
        axis = .vertical
        spacing = 16
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(buttonsHStack)
        
        buttonsHStack.addArrangedSubview(loginButton)
        buttonsHStack.addArrangedSubview(signUpButton)
    }
}

// MARK: - Preview

#Preview { MyPageLoggedOutInfoView() }
