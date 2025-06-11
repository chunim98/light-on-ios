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

final class SignUpSecondStepVC: BackButtonViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let userInfoSection = UserInfoSectionView()
    private let marketingSection = MarketingSectionView()
    private let policySection = PolicySectionView()
    
    private let privacyPolicyAlert = {
        let alert = PolicyDetailAlert()
        alert.titleLabel.config.text = "이용약관"
        alert.textView.setText("대충 엄청 긴 텍스트") // temp
        return alert
    }()
    
    private let nextButton = {
        let button = TPButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
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
        navigationBar.titleLabel.config.text = "회원가입"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(nextButton)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(userInfoSection)
        contentVStack.addArrangedSubview(marketingSection)
        contentVStack.addArrangedSubview(policySection)
        contentVStack.addArrangedSubview(Spacer(30))
        
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
        
    }
}

// MARK: - Preview

#Preview { SignUpSecondStepVC() }

