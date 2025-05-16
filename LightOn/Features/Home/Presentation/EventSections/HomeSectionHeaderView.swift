//
//  HomeSectionHeaderView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

import SnapKit

final class HomeSectionHeaderView: UIStackView {
    
    // MARK: Components
    
    let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.bold(23)
        label.textColor = .loBlack
        return label
    }()
    
     let arrowButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .homeSectionArrow).withTintColor(.assistive)
        config.imagePadding = .zero
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configuration
        inset = .init(top: 24, leading: 18, bottom: 12, trailing: 18)
        spacing = 8
        
        // Layout
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(UIView())
        addArrangedSubview(arrowButton)
        arrowButton.snp.makeConstraints { $0.width.equalTo(8) }
    }
}

// MARK: - Preview

#Preview { HomeSectionHeaderView() }
