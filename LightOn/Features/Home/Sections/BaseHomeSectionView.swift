//
//  BaseHomeSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

import SnapKit

class BaseHomeSectionView: UIStackView {
    
    // MARK: Components
    
    private let headerHStack = UIStackView(inset: .init(horizontal: 18))
    
    let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.text = "추천 공연"
        return LOLabel(config: config)
    }()
    
    let arrowButton = {
        var config = UIButton.Configuration.plain()
        config.image = .homeSectionArrow
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
        inset = .init(top: 24)
        axis = .vertical
        spacing = 12
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(headerHStack)
        headerHStack.addArrangedSubview(titleLabel)
        headerHStack.addArrangedSubview(arrowButton)
        arrowButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

// MARK: - Preview

#Preview { BaseHomeSectionView() }
