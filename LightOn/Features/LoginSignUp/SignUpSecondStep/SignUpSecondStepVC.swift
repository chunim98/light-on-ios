//
//  SignUpSecondStepVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit

import SnapKit

final class SignUpSecondStepVC: TPBackViewController {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let userInfoSection = UserInfoSectionView()
    private let marketingSection = MarketingSectionView()
    private let policySection = PolicySectionView()
    
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
}

// MARK: - Preview

#Preview { SignUpSecondStepVC() }

