//
//  LoginVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class LoginVC: NavigationBarVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = LoginDI.shared.makeLoginVM()
    
    private var signUpFlowCoord: SignUpFlowCoordinator?
    
    // MARK: Outputs
    
    private let loginCompleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    private let mainVStack = TapStackView(.vertical, alignment: .center)
    private let socialButtonHStack = UIStackView(spacing: 10)
    private let optionButtonHStack = UIStackView(spacing: 18)
    
    private let idForm = {
        let form = TextForm()
        form.textField.keyboardType = .emailAddress
        form.textField.setPlaceHolder("아이디 (이메일 주소)")
        form.titleLabel.config.text = "아이디"
        form.asteriskLabel.isHidden = true
        return form
    }()
    
    private let pwForm = {
        let form = TextForm()
        form.textField.isSecureTextEntry = true
        form.textField.setPlaceHolder("비밀번호")
        form.titleLabel.config.text = "비밀번호"
        form.asteriskLabel.isHidden = true
        return form
    }()
    
    private let loginButton = {
        let button = LOButton(style: .filled)
        button.setTitle("로그인", .pretendard.bold(16))
        return button
    }()
    
    private let loginElseDivider = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(12)
        config.foregroundColor = .assistive
        config.lineHeight = 30
        config.text = "또는"
        let label = LOLabel(config: config)
        
        let sv = UIStackView(alignment: .center, spacing: 16)
        sv.addArrangedSubview(LODivider(height: 1, color: .background))
        sv.addArrangedSubview(label)
        sv.addArrangedSubview(LODivider(height: 1, color: .background))
        label.snp.makeConstraints { $0.centerX.equalToSuperview() }
        return sv
    }()
    
    private let kakaoLoginButton  = SocialLoginButton(image: .loginSocialKakao)
    private let googleLoginButton = SocialLoginButton(image: .loginSocialGoogle)
    private let appleLoginButton  = SocialLoginButton(image: .loginSocialApple)
    
    let signUpButton    = LoginOptionButton(title: "회원가입")
    let findMyIDButton  = LoginOptionButton(title: "아이디 찾기")
    let findMyPWButton  = LoginOptionButton(title: "비밀번호 찾기")
    
    private let closeButton = {
        var config = UIButton.Configuration.plain()
        config.image = .selectLikingCross
        config.contentInsets = .zero
        return TouchInsetButton(configuration: config)
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
        navigationBar.rightItemHStack.addArrangedSubview(closeButton)
        navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(16))
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(LOSpacer(60))
        mainVStack.addArrangedSubview(UIImageView(image: .loginLogo))
        mainVStack.addArrangedSubview(LOSpacer(70))
        mainVStack.addArrangedSubview(idForm)
        mainVStack.addArrangedSubview(LOSpacer(24))
        mainVStack.addArrangedSubview(pwForm)
        mainVStack.addArrangedSubview(LOSpacer(40))
        mainVStack.addArrangedSubview(loginButton)
        mainVStack.addArrangedSubview(LOSpacer(23))
        mainVStack.addArrangedSubview(loginElseDivider)
        mainVStack.addArrangedSubview(LOSpacer(23))
        mainVStack.addArrangedSubview(socialButtonHStack)
        mainVStack.addArrangedSubview(LOSpacer(23))
        mainVStack.addArrangedSubview(optionButtonHStack)
        
        socialButtonHStack.addArrangedSubview(kakaoLoginButton)
        socialButtonHStack.addArrangedSubview(googleLoginButton)
        socialButtonHStack.addArrangedSubview(appleLoginButton)
        
        optionButtonHStack.addArrangedSubview(signUpButton)
        optionButtonHStack.addArrangedSubview(LODivider(width: 1, height: 12, color: .disable))
        optionButtonHStack.addArrangedSubview(findMyIDButton)
        optionButtonHStack.addArrangedSubview(LODivider(width: 1, height: 12, color: .disable))
        optionButtonHStack.addArrangedSubview(findMyPWButton)
        
        mainVStack.snp.makeConstraints { $0.top.horizontalEdges.equalTo(contentLayoutGuide) }
        idForm.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        pwForm.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        loginButton.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(34) }
        loginElseDivider.snp.makeConstraints { $0.horizontalEdges.equalToSuperview().inset(16) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let email = idForm.textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let pw = pwForm.textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = LoginVM.Input(
            email: email, pw: pw, loginTap: loginButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.loginComplete
            .sink { [weak self] in self?.loginCompleteSubject.send($0) }
            .store(in: &cancellables)
        
        signUpButton.tapPublisher
            .sink { [weak self] in self?.bindStartSignUpFlow() }
            .store(in: &cancellables)
        
        // 배경 탭, 키보드 닫기
        mainVStack.tapPublisher
            .sink { [weak self] _ in self?.mainVStack.endEditing(true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension LoginVC {
    /// 회원가입 플로우 시작 바인딩
    private func bindStartSignUpFlow() {
        signUpFlowCoord = .init(navigation: navigationController!, isInModal: false)
        signUpFlowCoord?.start()
    }
    
    /// 닫기 버튼 탭 퍼블리셔
    var closeTapPublisher: AnyPublisher<Void, Never> { closeButton.tapPublisher }
    
    /// 로그인 완료 이벤트 퍼블리셔
    var loginCompletePublisher: AnyPublisher<Void, Never> {
        loginCompleteSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { UINavigationController(rootViewController: LoginVC()) }
