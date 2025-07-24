//
//  DetailDescriptionSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

import SnapKit

final class DetailDescriptionSectionView: UIStackView {

    // MARK: Components
    
    private let contentVStack = {
        let sv = UIStackView(.vertical)
        sv.backgroundColor = .background
        sv.inset = .init(edges: 20)
        sv.layer.cornerRadius = 6
        sv.clipsToBounds = true
        sv.spacing = 12
        return sv
    }()
    
    private let titleHStack = {
        let iv = UIImageView(image: .performanceDetailNote)
        iv.contentMode = .scaleAspectFit
        
        var config = AttrConfiguration()
        config.font = .pretendard.bold(16)
        config.foregroundColor = .brand
        config.text = "공연 소개"
        let label = LOLabel(config: config)
        
        let sv = UIStackView()
        sv.spacing = 8
        sv.addArrangedSubview(iv)
        sv.addArrangedSubview(label)
        sv.addArrangedSubview(LOSpacer())
        return sv
    }()
    
    let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .loBlack
        config.paragraphSpacing = 8
        config.lineHeight = 23
        let label = LOLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
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
    
    private func setupDefaults() {
        inset = .init(horizontal: 18) + .init(top: 16, bottom: 40)
        axis = .vertical
    }
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(contentVStack)
        contentVStack.addArrangedSubview(titleHStack)
        contentVStack.addArrangedSubview(descriptionLabel)
    }
}

// MARK: - Preview

#Preview { DetailDescriptionSectionView() }
