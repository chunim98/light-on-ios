//
//  SignUpFirstStepVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class SignUpFirstStepVC: TPBackButtonViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = SignUpFirstStepVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let emailForm = {
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
    
    private let confirmForm = {
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
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "회원가입"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(Spacer(20))
        mainVStack.addArrangedSubview(emailForm)
        mainVStack.addArrangedSubview(Spacer(24))
        mainVStack.addArrangedSubview(pwForm)
        mainVStack.addArrangedSubview(Spacer(24))
        mainVStack.addArrangedSubview(confirmForm)
        mainVStack.addArrangedSubview(Spacer())
        mainVStack.addArrangedSubview(nextButton)
        
        emailForm.addTrailingView(Spacer(12))
        emailForm.addTrailingView(checkDuplicationButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
  
    // MARK: Bindings
    
    private func setupBindings() {
        
        let idText = emailForm.textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let pwText = pwForm.textField.textPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let confirmText = confirmForm.textField.textPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let input = SignUpFirstStepVM.Input(
            emailText: idText,
            pwText: pwText,
            confirmText: confirmText,
            duplicationTap: checkDuplicationButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.isNextButtonEnabled
            .sink { [weak self] in self?.nextButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.isDuplicationButtonEnabled
            .sink { [weak self] in self?.checkDuplicationButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.emailCaption
            .sink { [weak self] in self?.emailForm.captionConfigBinder(config: $0) }
            .store(in: &cancellables)
        
        output.pwCaption
            .sink { [weak self] in self?.pwForm.captionConfigBinder(config: $0) }
            .store(in: &cancellables)

        output.confirmCaption
            .sink { [weak self] in self?.confirmForm.captionConfigBinder(config: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { SignUpFirstStepVC() }
