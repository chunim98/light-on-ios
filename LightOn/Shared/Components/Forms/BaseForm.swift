//
//  BaseForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit

class BaseForm: UIStackView {
    
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
}

// MARK: - Preview

#Preview {
    let formContainer = BaseForm()
    formContainer.titleLabel.config.text = "안녕하세요"
    return formContainer
}
