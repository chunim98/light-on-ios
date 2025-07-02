//
//  SignUpSecondStepVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class SignUpSecondStepVC: BackButtonVC {
    
    // MARK: Properties
    
    private let vm: SignUpSecondStepVM
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let signUpCompletionSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    private let backgroundTapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let privacyInfoLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 24
        config.text = "개인정보 입력"
        return LOLabel(config: config)
    }()
    
    private let nameForm        = NameForm()
    private let phoneNumberForm = PhoneNumberForm()
    private let addressForm     = AddressForm()
    
    private let marketingSection = MarketingSectionView()
    private let termsSection = TermsSectionView()
    
    private let nextButton = {
        let button = LOButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: SignUpSecondStepVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupOverlayLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "회원가입"
        contentVStack.addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(nextButton)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(privacyInfoLabel)
        contentVStack.addArrangedSubview(LOSpacer(16))
        contentVStack.addArrangedSubview(nameForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(phoneNumberForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(addressForm)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(marketingSection)
        contentVStack.addArrangedSubview(termsSection)
        contentVStack.addArrangedSubview(LOSpacer(30))
        
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide).inset(18)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func setupOverlayLayout() {
        contentVStack.addSubview(addressForm.provinceTableContainer)
        contentVStack.addSubview(addressForm.cityTableContainer)
        
        addressForm.provinceTableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(addressForm.provinceButton)
            $0.height.equalTo(329)
        }
        addressForm.cityTableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(addressForm.cityButton)
            $0.height.equalTo(329)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = SignUpSecondStepVM.Input(
            name: nameForm.namePublisher,
            phone: phoneNumberForm.phoneNumberPublisher,
            regionCode: addressForm.regionIDPublisher,
            termsAgreed: termsSection.isAllAgreed,
            smsAgreed: marketingSection.smsCheckbox.isSelectedPublisher,
            pushAgreed: marketingSection.appPushCheckbox.isSelectedPublisher,
            emailAgreed: marketingSection.emailCheckbox.isSelectedPublisher,
            nextButtonTap: nextButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.nextButtonEnabled
            .sink { [weak self] in self?.nextButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.signUpCompletion
            .print("회원 가입 완료 이벤트")
            .sink { [weak self] in self?.signUpCompletionSubject.send($0) }
            .store(in: &cancellables)
        
        // 이용약관 상세 얼럿
        termsSection.servicePolicyDetailButton.tapPublisher
            .sink { [weak self] in self?.bindShowTermsAlert() }
            .store(in: &cancellables)
        
        // 개인정보 동의 상세 얼럿
        termsSection.privacyPolicyDetailButton.tapPublisher
            .sink { [weak self] in self?.bindShowPrivacyAlert() }
            .store(in: &cancellables)
        
        // 배경을 터치하면, 오버레이 닫기
        backgroundTapGesture.tapPublisher
            .sink { [weak self] in self?.bindDismissOverlay(gesture: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension SignUpSecondStepVC {
    /// 배경을 터치하면, 오버레이 닫기 (키보드 포함)
    private func bindDismissOverlay(gesture: UITapGestureRecognizer) {
        let provinceTableView = addressForm.provinceTableContainer
        let cityTableView = addressForm.cityTableContainer
        let point = gesture.location(in: contentVStack)
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !provinceTableView.isHidden, !provinceTableView.frame.contains(point) {
            provinceTableView.isHidden = true
        }
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !cityTableView.isHidden, !cityTableView.frame.contains(point) {
            cityTableView.isHidden = true
        }
        
        view.endEditing(true)   // 키보드 닫기
    }
    
    /// 이용약관 상세 얼럿 띄우기
    private func bindShowTermsAlert() {
        let alert = PolicyDetailAlert()
        alert.titleLabel.config.text = "이용약관"
        alert.textView.setText("대충 엄청 긴 텍스트") // temp
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true)
    }
    
    /// 개인정보 동의 상세 얼럿 띄우기
    private func bindShowPrivacyAlert() {
        let alert = PolicyDetailAlert()
        alert.titleLabel.config.text = "개인정보 수집 및 이용동의"
        alert.textView.setText("대충 엄청 긴 텍스트") // temp
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true)
    }
    
    /// 회원가입 완료 이벤트
    var signUpCompletion: AnyPublisher<Void, Never> {
        signUpCompletionSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { SignUpSecondStepVC(vm: .init(tempUserID: 0)) }

