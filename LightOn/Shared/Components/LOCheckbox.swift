//
//  LOCheckbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/4/25.
//

import UIKit

final class LOCheckbox: UIButton {
    
    // MARK: Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 16, height: 16)
    }
    
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
        self.setBackgroundImage(.checkboxUnchecked, for: .normal)
        self.setBackgroundImage(.checkboxChecked, for: .selected)
        self.addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }

    // MARK: Event Handling
    
    @objc private func handleTapEvent() { self.isSelected.toggle() }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 64, height: 64)) { LOCheckbox() }
