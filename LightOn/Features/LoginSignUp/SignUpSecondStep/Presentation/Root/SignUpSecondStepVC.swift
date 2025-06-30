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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let backgroundTapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let userInfoSection = UserInfoSectionView()
    
    private let phoneNumberForm = PhoneNumberForm()
    
    private let marketingSection = MarketingSectionView()
    private let policySection = PolicySectionView()
    
    private let privacyPolicyAlert = {
        let alert = PolicyDetailAlert()
        alert.titleLabel.config.text = "이용약관"
        alert.textView.setText("대충 엄청 긴 텍스트") // temp
        return alert
    }()
    
    private let nextButton = {
        let button = LOButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
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
        contentVStack.addArrangedSubview(userInfoSection)
        contentVStack.addArrangedSubview(phoneNumberForm)
        contentVStack.addArrangedSubview(marketingSection)
        contentVStack.addArrangedSubview(policySection)
        contentVStack.addArrangedSubview(LOSpacer(30))
        
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentLayoutGuide).inset(18)
            $0.bottom.equalTo(contentLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    private func setupOverlayLayout() {
        contentVStack.addSubview(userInfoSection.addressForm.provinceTableContainer)
        contentVStack.addSubview(userInfoSection.addressForm.cityTableContainer)
        
        userInfoSection.addressForm.provinceTableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(userInfoSection.addressForm.provinceButton)
            $0.height.equalTo(329)
        }
        userInfoSection.addressForm.cityTableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(userInfoSection.addressForm.cityButton)
            $0.height.equalTo(329)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        policySection.privacyPolicyDetailButton.tapPublisher
            .sink { [weak self] _ in
                print("되냐?")
                guard let self else { return }
                privacyPolicyAlert.modalPresentationStyle = .overFullScreen
                privacyPolicyAlert.modalTransitionStyle = .crossDissolve
                present(privacyPolicyAlert, animated: true)
            }
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
        let cityTableView = userInfoSection.addressForm.provinceTableContainer
        let townTableView = userInfoSection.addressForm.cityTableContainer
        let point = gesture.location(in: contentVStack)
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        
        if !cityTableView.isHidden, !cityTableView.frame.contains(point) {
            cityTableView.isHidden = true
        }
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !townTableView.isHidden, !townTableView.frame.contains(point) {
            townTableView.isHidden = true
        }
        
        view.endEditing(true)   // 키보드 닫기
    }
}

// MARK: - Preview

#Preview { SignUpSecondStepVC() }

