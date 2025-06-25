//
//  TPIconLabelContainer.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class TPIconLabelContainer: UIStackView {
    
    // MARK: Components
    
    let iconView = UIImageView(contentMode: .scaleAspectFit)
    
    let titleLabel = TPLabel(config: .init())
    
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
        iconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
