//
//  LoginVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

import SnapKit

final class LoginVC: BackButtonViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center)
    private let socialButtonHStack = UIStackView(spacing: 10)
    private let optionButtonHStack = UIStackView(spacing: 18)
    
    private let idForm = {
        let form = LoginForm()
        form.textField.setPlaceHolder("아이디 (이메일 주소)")
        form.titleLabel.config.text = "아이디"
        return form
    }()
    
    private let pwForm = {
        let form = LoginForm()
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("비밀번호")
        form.titleLabel.config.text = "비밀번호"
        return form
    }()
    
    private let loginButton = {
        let button = TPButton(style: .filled)
        button.setTitle("로그인", .pretendard.bold(16))
        return button
    }()
    
    private let loginElseDivider = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(12)
        config.foregroundColor = .assistive
        config.lineHeight = 30
        config.text = "또는"
        let label = TPLabel(config: config)
        
        let sv = UIStackView(alignment: .center, spacing: 16)
        sv.addArrangedSubview(Divider(height: 1, color: .background))
        sv.addArrangedSubview(label)
        sv.addArrangedSubview(Divider(height: 1, color: .background))
        label.snp.makeConstraints { $0.centerX.equalToSuperview() }
        return sv
    }()
    
    private let kakaoLoginButton  = SocialLoginButton(image: .loginSocialKakao)
    private let googleLoginButton = SocialLoginButton(image: .loginSocialGoogle)
    private let appleLoginButton  = SocialLoginButton(image: .loginSocialApple)
    
    let signUpButton = LoginOptionButton(title: "회원가입")
    let findMyIDButton = LoginOptionButton(title: "아이디 찾기")
    let findMyPWButton = LoginOptionButton(title: "비밀번호 찾기")
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(Spacer(60))
        mainVStack.addArrangedSubview(UIImageView(image: .loginLogo))
        mainVStack.addArrangedSubview(Spacer(70))
        mainVStack.addArrangedSubview(idForm)
        mainVStack.addArrangedSubview(Spacer(24))
        mainVStack.addArrangedSubview(pwForm)
        mainVStack.addArrangedSubview(Spacer(40))
        mainVStack.addArrangedSubview(loginButton)
        mainVStack.addArrangedSubview(Spacer(23))
        mainVStack.addArrangedSubview(loginElseDivider)
        mainVStack.addArrangedSubview(Spacer(23))
        mainVStack.addArrangedSubview(socialButtonHStack)
        mainVStack.addArrangedSubview(Spacer(23))
        mainVStack.addArrangedSubview(optionButtonHStack)
        
        socialButtonHStack.addArrangedSubview(kakaoLoginButton)
        socialButtonHStack.addArrangedSubview(googleLoginButton)
        socialButtonHStack.addArrangedSubview(appleLoginButton)
        
        optionButtonHStack.addArrangedSubview(signUpButton)
        optionButtonHStack.addArrangedSubview(Divider(width: 1, height: 12, color: .disable))
        optionButtonHStack.addArrangedSubview(findMyIDButton)
        optionButtonHStack.addArrangedSubview(Divider(width: 1, height: 12, color: .disable))
        optionButtonHStack.addArrangedSubview(findMyPWButton)

        mainVStack.snp.makeConstraints { $0.top.horizontalEdges.equalTo(contentLayoutGuide) }
        idForm.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        pwForm.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        loginButton.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        loginElseDivider.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(16) }
    }
}

// MARK: - Preview

#Preview { UINavigationController(rootViewController: LoginVC()) }
