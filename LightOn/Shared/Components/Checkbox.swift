//
//  Checkbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/4/25.
//

import UIKit

import SnapKit

final class Checkbox: UIButton {
    
    // MARK: Properties
    
    var titleConfig = TextConfiguration() { didSet {
        configuration?.attributedTitle = .init(textConfig: titleConfig)
    } }

    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleConfig.font = .pretendard.regular(14)
        titleConfig.foregroundColor = .caption
        titleConfig.lineHeight = 23
        
        configuration = UIButton.Configuration.filled()
        configuration?.attributedTitle = .init(textConfig: titleConfig)
        configuration?.baseBackgroundColor = .clear
        configuration?.imagePlacement = .leading
        configuration?.contentInsets = .zero
        configuration?.imagePadding = 6
        
        configurationUpdateHandler = {
            $0.configuration?.image = $0.isSelected ? .checkboxChecked : .checkboxUnchecked
        }

        addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }

    // MARK: Event Handling
    
    @objc private func handleTapEvent() { self.isSelected.toggle() }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 64, height: 64)) {
    let box = Checkbox()
    box.titleConfig.text = "이게 되네"
    return box
}
