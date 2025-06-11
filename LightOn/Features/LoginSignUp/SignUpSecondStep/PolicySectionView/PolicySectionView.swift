//
//  PolicySectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

import SnapKit

final class PolicySectionView: UIStackView {

    // MARK: Components
    
    private let checkboxFirstHStack = UIStackView(inset: .init(leading: 2))
    private let checkboxSecondHStack = UIStackView(inset: .init(leading: 18))
    private let checkboxThirdHStack = UIStackView(inset: .init(leading: 18))
    private let checkboxFourthHStack = UIStackView(inset: .init(leading: 18))
    
    private let policyHeaderLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "약관 동의"
        config.lineHeight = 24
        return TPLabel(config: config)
    }()
    
    let allAgreeCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.font = .pretendard.bold(14)
        box.titleConfig.text = "전체 동의합니다."
        return box
    }()

    let servicePolicyCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "이용약관에 동의합니다. (필수)"
        return box
    }()

    let privacyPolicyCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "개인정보 수집 및 이용에 동의합니다. (필수)"
        return box
    }()

    let over14Checkbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "만 14세 이상입니다. (필수)"
        return box
    }()
    
    let servicePolicyDetailButton = {
        var titleConfig = TextConfiguration()
        titleConfig.font = .pretendard.regular(12)
        titleConfig.foregroundColor = .clickable
        titleConfig.lineHeight = 23
        titleConfig.text = "내용보기"
        
        titleConfig.underlineStyle = .single
        titleConfig.underlineColor = .clickable
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(textConfig: titleConfig)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    let privacyPolicyDetailButton = {
        var titleConfig = TextConfiguration()
        titleConfig.font = .pretendard.regular(12)
        titleConfig.foregroundColor = .clickable
        titleConfig.lineHeight = 23
        titleConfig.text = "내용보기"
        
        titleConfig.underlineStyle = .single
        titleConfig.underlineColor = .clickable
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(textConfig: titleConfig)
        config.contentInsets = .zero
        return UIButton(configuration: config)
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
        addArrangedSubview(policyHeaderLabel)
        addArrangedSubview(Spacer(16))
        addArrangedSubview(checkboxFirstHStack)
        addArrangedSubview(Spacer(10))
        addArrangedSubview(checkboxSecondHStack)
        addArrangedSubview(Spacer(10))
        addArrangedSubview(checkboxThirdHStack)
        addArrangedSubview(Spacer(10))
        addArrangedSubview(checkboxFourthHStack)
        
        checkboxFirstHStack.addArrangedSubview(allAgreeCheckbox)
        checkboxFirstHStack.addArrangedSubview(Spacer())
        
        checkboxSecondHStack.addArrangedSubview(servicePolicyCheckbox)
        checkboxSecondHStack.addArrangedSubview(Spacer())
        checkboxSecondHStack.addArrangedSubview(servicePolicyDetailButton)
        
        checkboxThirdHStack.addArrangedSubview(privacyPolicyCheckbox)
        checkboxThirdHStack.addArrangedSubview(Spacer())
        checkboxThirdHStack.addArrangedSubview(privacyPolicyDetailButton)
        
        checkboxFourthHStack.addArrangedSubview(over14Checkbox)
        checkboxFourthHStack.addArrangedSubview(Spacer())
        
        servicePolicyCheckbox.setContentCompressionResistancePriority(.required, for: .horizontal)
        privacyPolicyCheckbox.setContentCompressionResistancePriority(.required, for: .horizontal)
        servicePolicyDetailButton.setContentHuggingPriority(.required, for: .horizontal)
        privacyPolicyDetailButton.setContentHuggingPriority(.required, for: .horizontal)
    }
}

// MARK: - Preview

#Preview { SignUpSecondStepVC() }
