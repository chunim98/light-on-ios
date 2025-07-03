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

final class SignUpFirstStepVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = LoginSignUpDI.shared.makeSignUpFirstStepVM()
    
    // MARK: Outputs
    
    private let tempUserIDSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Components
    
    private let backgroundTapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let mainVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let emailForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.setPlaceHolder("이메일 주소를 입력해주세요")
        form.titleLabel.config.text = "아이디"
        return form
    }()
    
    private let pwForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.textContentType = .oneTimeCode // 강력한 비번 생성 방지
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("8-20자리, 영어 대소문자, 숫자, 특수문자 조합")
        form.titleLabel.config.text = "비밀번호"
        return form
    }()
    
    private let confirmForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.textContentType = .oneTimeCode // 강력한 비번 생성 방지
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("8-20자리, 영어 대소문자, 숫자, 특수문자 조합")
        form.titleLabel.config.text = "비밀번호 확인"
        return form
    }()
    
    private let checkDuplicationButton = {
        let button = LOButton(style: .filled, width: 91)
        button.setTitle("중복확인", .pretendard.semiBold(16))
        return button
    }()
    
    private let nextButton = {
        let button = LOButton(style: .filled)
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
        mainVStack.addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(LOSpacer(20))
        mainVStack.addArrangedSubview(emailForm)
        mainVStack.addArrangedSubview(LOSpacer(24))
        mainVStack.addArrangedSubview(pwForm)
        mainVStack.addArrangedSubview(LOSpacer(24))
        mainVStack.addArrangedSubview(confirmForm)
        mainVStack.addArrangedSubview(LOSpacer())
        mainVStack.addArrangedSubview(nextButton)
        
        emailForm.addTrailingView(LOSpacer(12))
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
            duplicationTap: checkDuplicationButton.tapPublisher,
            nextButtonTap: nextButton.tapPublisher
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
        
        output.tempUserID
            .print()
            .sink { [weak self] in self?.tempUserIDSubject.send($0) }
            .store(in: &cancellables)
        
        backgroundTapGesture.tapPublisher
            .sink { [weak self] _ in self?.mainVStack.endEditing(true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension SignUpFirstStepVC {
    /// 임시 회원 번호 퍼블리셔
    var tempUserIDPublisher: AnyPublisher<Int, Never> {
        tempUserIDSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { SignUpFirstStepVC() }
