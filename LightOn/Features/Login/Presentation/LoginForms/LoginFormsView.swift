//
//  LoginFormsView.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

final class LoginFormsView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let idFormView = {
        let ff = LoginFormView()
        ff.setPlaceHolder("아이디 (이메일 주소)")
        ff.setTitleColor(.infoText)
        ff.setTitle("아이디")
        return ff
    }()
    
    private let pwFormView = {
        let ff = LoginFormView(isSecureTextEntry: true)
        ff.setPlaceHolder("비밀번호")
        ff.setTitleColor(.infoText)
        ff.setTitle("비밀번호")
        return ff
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
        inset = .init(horizontal: 18)
        axis = .vertical
        spacing = 24
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(idFormView)
        addArrangedSubview(pwFormView)
    }
}

// MARK: - Preview

#Preview { LoginFormsView() }
