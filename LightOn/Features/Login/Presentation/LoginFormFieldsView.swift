//
//  LoginFormFieldsView.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit

final class LoginFormFieldsView: UIStackView {
    
    // MARK: Components
    
    private let idFormField = {
        let ff = LOFormField()
        ff.setPlaceHolder("아이디 (이메일 주소)")
        ff.setTitle("아이디")
        return ff
    }()
    
    private let pwFormField = {
        let ff = LOFormField(isSecureTextEntry: true)
        ff.setPlaceHolder("비밀번호")
        ff.setTitle("비밀번호")
        return ff
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inset = .init(horizontal: 18)
        axis = .vertical
        spacing = 24
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(idFormField)
        addArrangedSubview(pwFormField)
    }
}

// MARK: - Preview

#Preview { LoginFormFieldsView() }
