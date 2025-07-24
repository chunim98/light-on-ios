//
//  DetailInfoSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

import SnapKit

final class DetailInfoSectionView: UIStackView {

    // MARK: Components
    
    private let genreTagHStack = UIStackView(alignment: .center)
    private let dateHStack = UIStackView(alignment: .center, spacing: 8)
    
    private let placeHStack = {
        let iv = UIImageView(image: .performanceDetailPin)
        iv.contentMode = .scaleAspectFit
        
        let sv = UIStackView(alignment: .center)
        sv.addArrangedSubview(iv)
        sv.addArrangedSubview(LOSpacer(6))
        return sv
    }()
    
    private let priceHStack = {
        let iv = UIImageView(image: .performanceDetailCard)
        iv.contentMode = .scaleAspectFit
        
        let sv = UIStackView(alignment: .center)
        sv.addArrangedSubview(iv)
        sv.addArrangedSubview(LOSpacer(6))
        return sv
    }()
    
    let shareButton = {
        var config = UIButton.Configuration.plain()
        config.image = .performanceDetailShare
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    let openMapButton = {
        let button = LinkButton()
        button.setTitle(
            title: "지도 보기",
            font: .pretendard.medium(14),
            color: .assistive
        )
        return button
    }()
    
    let genreTagLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(14)
        config.foregroundColor = .brand
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 8, vertical: 4)
        )
        label.backgroundColor = .xEEE7FB
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    let titleLabel = {
        var config = AttrConfiguration()
        config.lineBreakMode = .byTruncatingTail
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    let dateLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    let timeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    let placeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    let priceLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        return LOLabel(config: config)
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
        inset = .init(horizontal: 18) + .init(top: 40, bottom: 16)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(genreTagHStack)
        addArrangedSubview(LOSpacer(20))
        addArrangedSubview(titleLabel)
        addArrangedSubview(LOSpacer(12))
        addArrangedSubview(dateHStack)
        addArrangedSubview(LOSpacer(8))
        addArrangedSubview(placeHStack)
        addArrangedSubview(LOSpacer(8))
        addArrangedSubview(priceHStack)
        
        genreTagHStack.addArrangedSubview(genreTagLabel)
        genreTagHStack.addArrangedSubview(LOSpacer())
        genreTagHStack.addArrangedSubview(shareButton)
        
        dateHStack.addArrangedSubview(dateLabel)
        dateHStack.addArrangedSubview(LODivider(
            width: 1, height: 12, color: .disable
        ))
        dateHStack.addArrangedSubview(timeLabel)
        dateHStack.addArrangedSubview(LOSpacer())
        
        placeHStack.addArrangedSubview(placeLabel)
        placeHStack.addArrangedSubview(LOSpacer(8))
        placeHStack.addArrangedSubview(openMapButton)
        placeHStack.addArrangedSubview(LOSpacer())
        
        priceHStack.addArrangedSubview(priceLabel)
        priceHStack.addArrangedSubview(LOSpacer())
    }
}

// MARK: - Preview

#Preview { DetailInfoSectionView() }
