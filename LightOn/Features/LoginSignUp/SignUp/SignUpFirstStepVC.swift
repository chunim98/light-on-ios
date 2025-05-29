//
//  SignUpFirstStepVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit

import SnapKit

final class SignUpFirstStepVC: TPBackViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let idForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.setPlaceHolder("이메일 주소를 입력해주세요")
        form.titleLabel.config.text = "아이디"
        return form
    }()
    
    private let pwForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("8-20자리, 영어 대소문자, 숫자, 특수문자 조합")
        form.titleLabel.config.text = "비밀번호"
        return form
    }()
    
    private let pwConfirmForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("8-20자리, 영어 대소문자, 숫자, 특수문자 조합")
        form.titleLabel.config.text = "비밀번호 확인"
        return form
    }()
    
    private let checkDuplicationButton = {
        let button = TPButton(style: .filled, width: 91)
        button.setTitle("중복확인", .pretendard.semiBold(16))
        return button
    }()
    
    private let nextButton = {
        let button = TPButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "회원가입"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(Spacer(20))
        mainVStack.addArrangedSubview(idForm)
        mainVStack.addArrangedSubview(Spacer(24))
        mainVStack.addArrangedSubview(pwForm)
        mainVStack.addArrangedSubview(Spacer(24))
        mainVStack.addArrangedSubview(pwConfirmForm)
        mainVStack.addArrangedSubview(Spacer())
        mainVStack.addArrangedSubview(nextButton)
        
        idForm.addTrailingView(Spacer(12))
        idForm.addTrailingView(checkDuplicationButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
  
}

// MARK: - Preview

#Preview { SignUpFirstStepVC() }
