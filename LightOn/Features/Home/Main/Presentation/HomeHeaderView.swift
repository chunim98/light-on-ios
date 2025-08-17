//
//  HomeHeaderView.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit

import SnapKit

final class HomeHeaderView: UIStackView {
    
    // MARK: Components
    
    let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(20)
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    let button = {
        var config = UIButton.Configuration.plain()
        config.image = .homeSectionArrow
        let button = TouchInsetButton(configuration: config)
        button.snp.makeConstraints { $0.size.equalTo(15) }
        return button
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
        inset = .init(horizontal: 18) + .init(top: 24, bottom: 12)
        insetsLayoutMarginsFromSafeArea = false // 세이프에어리어 자동 합산 끔
        alignment = .center
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(button)
    }
}

// MARK: - Preview

#Preview { HomeHeaderView() }
