//
//  PhoneNumberForm.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PhoneNumberForm: TextForm {

    // MARK: Properties
    
    private let vm = SignUpDI.shared.makePhoneNumberFormVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let phoneNumberSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
    private let authCodeHStack = UIStackView()
    
    private let requestButton = {
        let button = LOButton(style: .filled, width: 95)
        button.setTitle("인증 받기", .pretendard.semiBold(16))
        return button
    }()
    
    private let retryButton = {
        let button = LOButton(style: .bordered, width: 78)
        button.setTitle("재전송", .pretendard.regular(16))
        button.configuration?.background.strokeColor = .thumbLine
        return button
    }()

    private let confirmButton = {
        let button = LOButton(style: .filled, width: 64)
        button.setTitle("확인", .pretendard.semiBold(16))
        return button
    }()
    
    private let authCodeTextField = LOTintedTextField()
    
    private let timeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .brand
        config.underlineStyle = .single
        config.underlineColor = .brand
        config.lineHeight = 23
        config.text = "00:00"
        return LOLabel(config: config)
    }()
    
    private let captionView = PhoneNumberFormCaptionView()
        
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
        textField.setPlaceHolder("휴대폰 번호를 입력해주세요.")
        titleLabel.config.text = "휴대폰 번호"
        textField.keyboardType = .numberPad // 숫자 키보드 제한
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(authCodeHStack)
        addArrangedSubview(captionView)
        
        textFieldHStack.addArrangedSubview(LOSpacer(12))
        textFieldHStack.addArrangedSubview(requestButton)

        authCodeHStack.addArrangedSubview(authCodeTextField)
        authCodeHStack.addArrangedSubview(LOSpacer(12))
        authCodeHStack.addArrangedSubview(retryButton)
        authCodeHStack.addArrangedSubview(LOSpacer(7))
        authCodeHStack.addArrangedSubview(confirmButton)
        
        authCodeTextField.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        let phoneNumber = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let authCode = authCodeTextField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        /// 연속 터치를 막고자 0.75초 뒤에 이벤트 방출
        let debouncedRetryTap = retryButton.tapPublisher
            .debounce(for: 0.75, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        
        let input = PhoneNumberFormVM.Input(
            phoneNumber: phoneNumber,
            authCode: authCode,
            requestTap: requestButton.tapPublisher,
            retryTap: debouncedRetryTap,
            confirmTap: confirmButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState($0) }
            .store(in: &cancellables)
        
        output.validPhoneNumber
            .sink { [weak self] in self?.phoneNumberSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PhoneNumberForm {
    /// 화면 상태 바인딩
    private func bindState(_ state: PhoneNumberFormState) {
        // 스타일
        requestButton.isEnabled = state.style.requestButtonEnabled
        confirmButton.isEnabled = state.style.confirmButtonEnabled
        authCodeHStack.isHidden = state.style.authCodeHStackHidden
        captionView.isHidden = state.style.captionViewHidden
        // 값
        authCodeTextField.text = state.authCode
        timeLabel.config.text = state.time
    }
    
    /// 최종 인증된 폰번호 퍼블리셔
    var phoneNumberPublisher: AnyPublisher<String?, Never> {
        phoneNumberSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { PhoneNumberForm() }
