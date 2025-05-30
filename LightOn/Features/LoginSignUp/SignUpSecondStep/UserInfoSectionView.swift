//
//  UserInfoSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

final class UserInfoSectionView: UIStackView {

    // MARK: Components
    
    private let userInfoHeaderLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .blackLO
        config.text = "개인정보 입력"
        config.lineHeight = 24
        return TPLabel(config: config)
    }()
    
    let nameForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.setPlaceHolder("이름을 입력해주세요.")
        form.titleLabel.config.text = "이름"
        return form
    }()
    
    let phoneNumberForm = {
        let form = SignUpTextForm(isRequired: true)
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("휴대폰 번호를 입력해주세요.")
        form.titleLabel.config.text = "휴대폰 번호"
        return form
    }()
    
    let codeForm = VerifyCodeForm()
    
    let addressForm = AddressButtonForm()
    
    let requestCodeButton = {
        let button = TPButton(style: .filled, width: 91)
        button.setTitle("인증 받기", .pretendard.semiBold(16))
        return button
    }()
    
    let retryButton = {
        let button = TPButton(style: .bordered, width: 78)
        button.setTitle("재전송", .pretendard.regular(16))
        button.configuration?.background.strokeColor = .thumbLine
        return button
    }()

    let codeConfirmButton = {
        let button = TPButton(style: .filled, width: 64)
        button.setTitle("확인", .pretendard.semiBold(16))
        return button
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
        inset = .init(horizontal: 18, vertical: 20)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(userInfoHeaderLabel)
        addArrangedSubview(Spacer(16))
        addArrangedSubview(nameForm)
        addArrangedSubview(Spacer(24))
        addArrangedSubview(phoneNumberForm)
        addArrangedSubview(codeForm)
        addArrangedSubview(Spacer(24))
        addArrangedSubview(addressForm)
        
        phoneNumberForm.addTrailingView(Spacer(12))
        phoneNumberForm.addTrailingView(requestCodeButton)
        
        codeForm.addTrailingView(Spacer(12))
        codeForm.addTrailingView(retryButton)
        codeForm.addTrailingView(Spacer(7))
        codeForm.addTrailingView(codeConfirmButton)
    }
}
