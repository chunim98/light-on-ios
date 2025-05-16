//
//  LoginElseDivider.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit

import SnapKit

final class LoginElseDivider: UIStackView {

    // MARK: Components
    
    private let leftDivider = LODivider(width: 1, color: .background)
    private let rightDivider = LODivider(width: 1, color: .background)
    private let elseLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(12)
        label.textColor = .assistive
        label.text = "또는"
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alignment = .center
        spacing = 16
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(leftDivider)
        addArrangedSubview(elseLabel)
        addArrangedSubview(rightDivider)
        elseLabel.snp.makeConstraints { $0.centerX.equalToSuperview() }
    }
}

#Preview { LoginElseDivider() }
