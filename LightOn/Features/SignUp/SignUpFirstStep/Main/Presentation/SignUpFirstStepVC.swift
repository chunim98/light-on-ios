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
    private let vm = SignUpDI.shared.makeSignUpFirstStepVM()
    
    /// 모달로 진입했는지 여부
    private let isInModal: Bool
    
    // MARK: Outputs
    
    private let tempUserIDSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Components
    
    private let mainVStack = TapStackView(.vertical, inset: .init(horizontal: 18))
    
    private let emailForm = EmailValidationForm()
    private let pwForm = PasswordValidationForm()
    private let confirmForm = ConfirmPasswordForm()
    
    private let nextButton = {
        let button = LOButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    private let closeButton = {
        var config = UIButton.Configuration.plain()
        config.image = .selectLikingCross
        config.contentInsets = .zero
        return TouchInsetButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    init(isInModal: Bool) {
        self.isInModal = isInModal
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "회원가입"
        navigationBar.rightItemHStack.addArrangedSubview(closeButton)
        navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(16))
        
        backBarButton.isHidden = isInModal
        closeButton.isHidden = !isInModal
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
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = SignUpFirstStepVM.Input(
            emailText: emailForm.emailPublisher,
            pwText: pwForm.passwordPublisher,
            confirmText: confirmForm.confirmPasswordPublisher,
            nextButtonTap: nextButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.isNextButtonEnabled
            .sink { [weak self] in self?.nextButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.tempUserID
            .sink { [weak self] in self?.tempUserIDSubject.send($0) }
            .store(in: &cancellables)
        
        pwForm.passwordPublisher
            .sink { [weak self] in self?.confirmForm.bindOriginPassword($0) }
            .store(in: &cancellables)
        
        mainVStack.tapPublisher
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
    
    /// 닫기 버튼 탭 퍼블리셔
    var closeTapPublisher: AnyPublisher<Void, Never> {
        closeButton.tapPublisher
    }
}

// MARK: - Preview

#Preview { SignUpFirstStepVC(isInModal: false) }
