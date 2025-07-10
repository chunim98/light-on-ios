//
//  ConfirmPasswordForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ConfirmPasswordForm: SignUpFirstStepBaseForm {
    
    // MARK: Properties
    
    private let vm = ConfirmPasswordFormVM()
    
    // MARK: Inputs
    
    private let originPasswordSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Outputs
    
    private let vaildConfirmPasswordSubject = PassthroughSubject<String?, Never>()
    
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
        titleLabel.config.text = "비밀번호 확인"
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let confirmPassword = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = ConfirmPasswordFormVM.Input(
            confirmPassword: confirmPassword,
            originPassword: originPasswordSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
        
        output.vaildConfirmPassword
            .sink { [weak self] in self?.vaildConfirmPasswordSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ConfirmPasswordForm {
    /// 상태 바인딩
    private func bindState(state: ConfirmPasswordFormState) {
        captionView.setCaption(state: {
            switch state.matchingState {
            case .originBadFormat:  .invalid("비밀번호는 영문, 숫자, 특수문자 모두 포함된 8자 이상이어야 합니다.")
            case .notMatched:       .invalid("비밀번호가 일치하지 않습니다.")
            case .matched:          .valid("비밀번호가 일치합니다.")
            case .unknown:          .hidden
            }
        }())
    }
    
    /// 비교할 비밀번호 바인딩
    func bindOriginPassword(_ password: String?) {
        originPasswordSubject.send(password)
    }
    
    /// 유효한 확인 비밀번호 퍼블리셔
    var confirmPasswordPublisher: AnyPublisher<String?, Never> {
        vaildConfirmPasswordSubject.eraseToAnyPublisher()
    }
}
