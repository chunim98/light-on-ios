//
//  AddressForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/27/25.
//

import UIKit

final class AddressForm: BaseForm {

    // MARK: Components
    
    private let mainHStack = {
        let sv = UIStackView(spacing: 12)
        sv.distribution = .fillEqually
        return sv
    }()
    
    let cityButton = {
        let button = AddressFormButton()
        button.titleConfig.text = "도/시/군"
        return button
    }()
    
    let townButton = {
        let button = AddressFormButton()
        button.titleConfig.text = "읍/면/동"
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "선호 지역" }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(mainHStack)
        mainHStack.addArrangedSubview(cityButton)
        mainHStack.addArrangedSubview(townButton)
    }
}

// MARK: - Preview

#Preview {
    AddressForm()
}
