//
//  MarketingSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

final class MarketingSectionView: UIStackView {

    // MARK: Components
    
    private let checkboxFirstHStack = UIStackView(inset: .init(horizontal: 2))
    private let checkboxSecondHStack = UIStackView(spacing: 18, inset: .init(horizontal: 2))
    
    private let marketingHeaderLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "마케팅 정보 수신 (선택)"
        config.lineHeight = 24
        return TPLabel(config: config)
    }()
    
    private let marketingCaptionLabel = {
        var config = TextConfiguration()
        config.text = "* 수신 동의 상태는 개인 설정에서 별도로 변경할 수 있습니다."
        config.font = .pretendard.regular(12)
        config.foregroundColor = .infoText
        config.lineHeight = 14
        return TPPaddingLabel(configuration: config, padding: .init(left: 2))
    }()
    
    let entryMethodCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "출입 방법 저장"
        return box
    }()
    
    let smsCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "SMS"
        return box
    }()
    
    let appPushCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "앱 푸시"
        return box
    }()
    
    let emailCheckbox = {
        let box = TPCheckbox()
        box.titleConfig.text = "이메일"
        return box
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
        addArrangedSubview(marketingHeaderLabel)
        addArrangedSubview(Spacer(16))
        addArrangedSubview(checkboxFirstHStack)
        addArrangedSubview(Spacer(10))
        addArrangedSubview(checkboxSecondHStack)
        addArrangedSubview(Spacer(4))
        addArrangedSubview(marketingCaptionLabel)
        
        checkboxFirstHStack.addArrangedSubview(entryMethodCheckbox)
        checkboxFirstHStack.addArrangedSubview(Spacer())
        
        checkboxSecondHStack.addArrangedSubview(smsCheckbox)
        checkboxSecondHStack.addArrangedSubview(appPushCheckbox)
        checkboxSecondHStack.addArrangedSubview(emailCheckbox)
        checkboxSecondHStack.addArrangedSubview(Spacer())
    }
}
