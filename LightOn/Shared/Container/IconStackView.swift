//
//  IconStackView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

final class IconStackView: UIStackView {
    
    // MARK: Components
    
    let iconView = UIImageView(contentMode: .scaleAspectFit)
        
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
    
    private func setupDefaults() { alignment = .center }
    
    // MARK: Layout
    
    private func setupLayout() {
        iconView.setContentHuggingPriority(.required, for: .horizontal)
    }
}
