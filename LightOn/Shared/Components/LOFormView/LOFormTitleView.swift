//
//  LOFormTitleView.swift
//  LightOn
//
//  Created by 신정욱 on 5/17/25.
//

import UIKit

final class LOFormTitleView: UIStackView {
    
    // MARK: Components
    
    private let essentialMarkLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        label.textColor = .destructive
        label.text = "*"
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        return label
    }()
    
    // MARK: Life Cycle
    
    init(isEssential: Bool = true) {
        essentialMarkLabel.isHidden = !isEssential
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 16)
        spacing = 2
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(essentialMarkLabel)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: Public Configuration
    
    func setText(_ text: String) { titleLabel.text = text }
    func setColor(_ color: UIColor) { titleLabel.textColor = color }
    func setEssentialMarkVisibility(_ visibility: Bool) {
        essentialMarkLabel.isHidden = !visibility
    }
}

// MARK: - Preview

#Preview {
    let ftv = LOFormTitleView()
    ftv.setText("아이디")
    ftv.setColor(.loBlack)
    return ftv
}
