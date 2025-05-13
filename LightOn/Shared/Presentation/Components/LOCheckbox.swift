//
//  LOCheckbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/4/25.
//

import UIKit

final class LOCheckbox: UIButton {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configure() {
        self.setBackgroundImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        self.setBackgroundImage(UIImage(named: "checkbox_checked"), for: .selected)
        self.addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }
    
    // MARK: Overrides
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 16, height: 16)
    }
    
    // MARK: Event Handling
    
    @objc private func handleTapEvent() {
        self.isSelected.toggle()
    }
}

#Preview(traits: .fixedLayout(width: 64, height: 64)) { LOCheckbox() }
