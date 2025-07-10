//
//  EmailValidationForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class EmailValidationForm: SignUpFirstStepBaseForm {
    
    // MARK: Properties
    
    private let vm = SignUpDI.shared.makeEmailValidationFormVM()
    
    // MARK: Outputs
    
    private let validEmailSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
    private let checkDuplicationButton = {
        let button = LOButton(style: .filled, width: 91)
        button.setTitle("중복확인", .pretendard.semiBold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textField.setPlaceHolder("이메일 주소를 입력해주세요.")
        titleLabel.config.text = "아이디"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        textFieldHStack.addArrangedSubview(LOSpacer(12))
        textFieldHStack.addArrangedSubview(checkDuplicationButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let email = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = EmailValidationFormVM.Input(
            email: email,
            checkDuplicationTap: checkDuplicationButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
        
        output.validEmail
            .sink { [weak self] in self?.validEmailSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension EmailValidationForm {
    /// 상태 바인딩
    private func bindState(state: EmailValidationFormState) {
        captionView.setCaption(state: {
            switch (state.format, state.duplication) {
            case (.invalid, _):             return .invalid("올바른 메일주소를 입력하세요.")
            case (_, .duplicated):          return .invalid("중복된 이메일 주소입니다.")
            case (.valid, .notDuplicated):  return .valid("사용 가능한 아이디입니다.")
            default:                        return .hidden
            }
        }())
        checkDuplicationButton.isEnabled = state.format == .valid
    }
    
    /// 유효한 이메일 퍼블리셔
    var emailPublisher: AnyPublisher<String?, Never> {
        validEmailSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { EmailValidationForm() }
