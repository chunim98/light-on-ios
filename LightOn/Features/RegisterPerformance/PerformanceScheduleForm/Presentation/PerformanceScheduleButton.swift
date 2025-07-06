//
//  PerformanceScheduleButton.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit

import SnapKit

final class PerformanceScheduleButton: UIButton {
    
    // MARK: Properties
    
    private var config = Configuration.plain()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 47)
    }
    
    // MARK: Components
    
    private let mainHStack = UIStackView(
        alignment: .center, inset: .init(horizontal: 18, vertical: 12)
    )
    
    let iconView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(24) }
        return iv
    }()
    
    private let arrowView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .arrowDown
        iv.snp.makeConstraints { $0.size.equalTo(16) }
        return iv
    }()
    
    let _titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        config.contentInsets = .zero
        
        config.background.strokeWidth = 1
        
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        configuration = config
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(mainHStack)
        mainHStack.addArrangedSubview(iconView)
        mainHStack.addArrangedSubview(LOSpacer(6))
        mainHStack.addArrangedSubview(_titleLabel)
        mainHStack.addArrangedSubview(LOSpacer())
        mainHStack.addArrangedSubview(arrowView)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension PerformanceScheduleButton {
    /// 버튼 스타일 바인딩
    func bindStyle(style: PerformanceScheduleButtonStyle) {
        arrowView.image = arrowView.image?.withTintColor(style.arrowColor)
        iconView.image = iconView.image?.withTintColor(style.iconColor)
        _titleLabel.config.foregroundColor = style.titleColor
        config.background.strokeColor = style.strokeColor
        configuration = config
    }
}
