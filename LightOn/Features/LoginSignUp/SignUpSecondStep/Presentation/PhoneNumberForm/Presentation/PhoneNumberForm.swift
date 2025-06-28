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
    
    private let vm = PhoneNumberFormVM()
    private var cancellables = Set<AnyCancellable>()
    
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
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .brand
        config.underlineStyle = .single
        config.underlineColor = .brand
        config.lineHeight = 23
        config.text = "00:00"
        return LOLabel(config: config)
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
        textField.setPlaceHolder("휴대폰 번호를 입력해주세요.")
        titleLabel.config.text = "휴대폰 번호"
        textField.keyboardType = .numberPad // 숫자 키보드 제한
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(authCodeHStack)
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
        self.snp.makeConstraints { $0.width.equalTo(350) }
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
        
        let input = PhoneNumberFormVM.Input(
            phoneNumber: phoneNumber,
            authCode: authCode,
            requestTap: requestButton.tapPublisher,
            retryTap: retryButton.tapPublisher,
            confirmTap: confirmButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .handleEvents(
                receiveSubscription: { _ in print("구독 시작됐다냥") },
                receiveOutput: { value in print("값 받았당: \(value)") },
                receiveCompletion: { completion in
                    print("완료됐당냥: \(completion)")  // 여기서 .finished 또는 .failure 확인 가능
                },
                receiveCancel: { print("취소됐다냥") }
            )            .sink { [weak self] in self?.bindState($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PhoneNumberForm {
    /// 화면 상태 바인딩
    private func bindState(_ state: PhoneNumberFormState) {
        timeLabel.config.text = state.time
        authCodeHStack.isHidden = state.authCodeHStackHidden
        requestButton.isEnabled = state.requestButtonEnabled
        confirmButton.isEnabled = state.confirmButtonEnabled
    }
}

// MARK: - Preview

#Preview { PhoneNumberForm() }
