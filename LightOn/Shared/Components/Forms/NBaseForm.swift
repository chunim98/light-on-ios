//
//  NBaseForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit

class NBaseForm: UIStackView {
    
    // MARK: Components
    
    let titleHStack = UIStackView(spacing: 2, inset: .init(horizontal: 16))
    
    let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(14)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    let asteriskLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(14)
        config.foregroundColor = .destructive
        config.text = "*"
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel.config.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 6
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleHStack)
        titleHStack.addArrangedSubview(titleLabel)
        titleHStack.addArrangedSubview(asteriskLabel)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: Style
    
    /// 상태별 스타일 설정
    func setStyle(status: FormStatus) {
        switch status {
        case .empty:    titleLabel.config.foregroundColor = .caption
        case .editing:  titleLabel.config.foregroundColor = .brand
        case .filled:   titleLabel.config.foregroundColor = .caption
        case .invalid:  titleLabel.config.foregroundColor = .destructive
        }
    }
}


