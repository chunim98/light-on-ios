//
//  PasswordValidationForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit
import Combine

import SnapKit

final class PasswordValidationForm: SignUpFirstStepBaseForm {
    
    // MARK: Properties
    
    private let vm = PasswordValidationFormVM()
    
    // MARK: Outputs
    
    private let vaildPasswordSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textField.setPlaceHolder("8-20자리, 영어 대소문자, 숫자, 특수문자 조합")
        textField.isSecureTextEntry = true
        titleLabel.config.text = "비밀번호"
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let password = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = PasswordValidationFormVM.Input(password: password)
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
        
        output.vaildPassword
            .sink { [weak self] in self?.vaildPasswordSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PasswordValidationForm {
    /// 상태 바인딩
    private func bindState(state: PasswordValidationFormState) {
        captionView.setCaption(state: {
            switch state.format {
            case .unknown:  .hidden
            case .valid:    .valid("사용 가능한 비밀번호 입니다.")
            case .invalid:  .invalid("비밀번호는 영문, 숫자, 특수문자 모두 포함된 8자 이상이어야 합니다.")
            }
        }())
    }
    
    /// 유효한 비밀번호 퍼블리셔
    var passwordPublisher: AnyPublisher<String?, Never> {
        vaildPasswordSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { PasswordValidationForm() }
