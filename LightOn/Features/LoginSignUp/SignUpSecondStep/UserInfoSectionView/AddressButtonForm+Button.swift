//
//  AddressButtonForm+Button.swift
//  TennisPark
//
//  Created by 신정욱 on 5/27/25.
//

import UIKit

import SnapKit

extension AddressButtonForm {
final class Button: UIButton {
    
    // MARK: Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 47)
    }
    
    // MARK: Components
    
    let iconLabelStack = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .assistive
        
        let il = TPIconLabelContainer()
        il.inset = .init(horizontal: 18)
        il.iconView.image = .signUpArrow
        il.titleLabel.config = config
        
        il.addArrangedSubview(il.titleLabel)
        il.addArrangedSubview(Spacer())
        il.addArrangedSubview(il.iconView)
        return il
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
        var config = UIButton.Configuration.filled()
        config.background.strokeColor = .thumbLine
        config.background.strokeWidth = 1
        
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        config.baseBackgroundColor = .white
        configuration = config
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(iconLabelStack)
        iconLabelStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func setSelectedTitle(_ text: String) {
        iconLabelStack.titleLabel.config.foregroundColor = .blackLO
        iconLabelStack.titleLabel.config.text = text
    }
}
}

// MARK: - Preview

#Preview { AddressButtonForm.Button() }
