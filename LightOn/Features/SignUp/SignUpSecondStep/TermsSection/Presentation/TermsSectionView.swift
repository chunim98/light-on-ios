//
//  TermsSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class TermsSectionView: UIStackView {
    
    // MARK: Properties
    
    private let vm = TermsSectionVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let isAllAgreedSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: Components
    
    private let checkboxFirstHStack = UIStackView(inset: .init(leading: 2))
    private let checkboxSecondHStack = UIStackView(inset: .init(leading: 18))
    private let checkboxThirdHStack = UIStackView(inset: .init(leading: 18))
    private let checkboxFourthHStack = UIStackView(inset: .init(leading: 18))
    
    private let policyHeaderLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "약관 동의"
        config.lineHeight = 24
        return LOLabel(config: config)
    }()
    
    private let allAgreeCheckbox = {
        let box = Checkbox()
        box.titleConfig.font = .pretendard.bold(14)
        box.titleConfig.text = "전체 동의합니다."
        return box
    }()
    
    private let servicePolicyCheckbox = {
        let box = Checkbox()
        box.titleConfig.text = "이용약관에 동의합니다. (필수)"
        return box
    }()
    
    private let privacyPolicyCheckbox = {
        let box = Checkbox()
        box.titleConfig.text = "개인정보 수집 및 이용에 동의합니다. (필수)"
        return box
    }()
    
    private let over14Checkbox = {
        let box = Checkbox()
        box.titleConfig.text = "만 14세 이상입니다. (필수)"
        return box
    }()
    
    let servicePolicyDetailButton = {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.regular(12)
        titleConfig.foregroundColor = .clickable
        titleConfig.lineHeight = 23
        titleConfig.text = "내용보기"
        
        titleConfig.underlineStyle = .single
        titleConfig.underlineColor = .clickable
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(config: titleConfig)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    let privacyPolicyDetailButton = {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.regular(12)
        titleConfig.foregroundColor = .clickable
        titleConfig.lineHeight = 23
        titleConfig.text = "내용보기"
        
        titleConfig.underlineStyle = .single
        titleConfig.underlineColor = .clickable
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(config: titleConfig)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(vertical: 20)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(policyHeaderLabel)
        addArrangedSubview(LOSpacer(16))
        addArrangedSubview(checkboxFirstHStack)
        addArrangedSubview(LOSpacer(10))
        addArrangedSubview(checkboxSecondHStack)
        addArrangedSubview(LOSpacer(10))
        addArrangedSubview(checkboxThirdHStack)
        addArrangedSubview(LOSpacer(10))
        addArrangedSubview(checkboxFourthHStack)
        
        checkboxFirstHStack.addArrangedSubview(allAgreeCheckbox)
        checkboxFirstHStack.addArrangedSubview(LOSpacer())
        
        checkboxSecondHStack.addArrangedSubview(servicePolicyCheckbox)
        checkboxSecondHStack.addArrangedSubview(LOSpacer())
        checkboxSecondHStack.addArrangedSubview(servicePolicyDetailButton)
        
        checkboxThirdHStack.addArrangedSubview(privacyPolicyCheckbox)
        checkboxThirdHStack.addArrangedSubview(LOSpacer())
        checkboxThirdHStack.addArrangedSubview(privacyPolicyDetailButton)
        
        checkboxFourthHStack.addArrangedSubview(over14Checkbox)
        checkboxFourthHStack.addArrangedSubview(LOSpacer())
        
        servicePolicyCheckbox.setContentCompressionResistancePriority(.required, for: .horizontal)
        privacyPolicyCheckbox.setContentCompressionResistancePriority(.required, for: .horizontal)
        servicePolicyDetailButton.setContentHuggingPriority(.required, for: .horizontal)
        privacyPolicyDetailButton.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = TermsSectionVM.Input(
            serviceAgreed: servicePolicyCheckbox.isSelectedPublisher,
            privacyAgreed: privacyPolicyCheckbox.isSelectedPublisher,
            isOver14: over14Checkbox.isSelectedPublisher,
            allAgreed: allAgreeCheckbox.isSelectedPublisher
        )
        
        let output = vm.transform(input)
        
        output.isAllAgreed
            .sink { [weak self] in
                self?.allAgreeCheckbox.isSelected = $0
                self?.isAllAgreedSubject.send($0)
            }
            .store(in: &cancellables)
        
        output.policySectionState
            .sink { [weak self] in
                self?.servicePolicyCheckbox.isSelected = $0.serviceAgreed
                self?.privacyPolicyCheckbox.isSelected = $0.privacyAgreed
                self?.over14Checkbox.isSelected = $0.isOver14
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension TermsSectionView {
    /// 항목에 모두 동의했는지 여부
    var isAllAgreed: AnyPublisher<Bool, Never> {
        isAllAgreedSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    SignUpSecondStepVC(vm: .init(
        tempUserID: 0,
        signUpRepo: DefaultSignUpRepo()
    ))
}
