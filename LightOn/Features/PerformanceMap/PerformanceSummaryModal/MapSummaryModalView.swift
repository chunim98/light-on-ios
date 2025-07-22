//
//  MapSummaryModalView.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MapSummaryModalView: MapBaseModalView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Containers
    
    private let mainVStack      = UIStackView(.vertical, inset: .init(horizontal: 18))
    private let buttonsHStack   = UIStackView(alignment: .center)
    private let genreTagHStack  = UIStackView()
    
    private let dateHStack = {
        let divider = LODivider(width: 1, height: 12, color: .disable)
        let sv = UIStackView(alignment: .center, spacing: 8)
        sv.addArrangedSubview(divider)
        return sv
    }()
    
    private let placeHStack = {
        let iv = UIImageView(image: .performanceDetailPin)
        iv.contentMode = .scaleAspectFit
        let sv = UIStackView(alignment: .center)
        sv.addArrangedSubview(iv)
        sv.addArrangedSubview(LOSpacer(6))
        return sv
    }()
    
    private let showDetailHStack = UIStackView(inset: .init(horizontal: 16))
    
    // MARK: Buttons
    
    let backButton = {
        var config = UIButton.Configuration.plain()
        config.image = .mapArrowLeft
        config.contentInsets = .zero
        return TouchInsetButton(configuration: config)
    }()
    
    let shareButton = {
        var config = UIButton.Configuration.plain()
        config.image = .mapShare
        config.contentInsets = .zero
        return TouchInsetButton(configuration: config)
    }()
    
    let showDetailButton = {
        let button = LOButton(style: .filled, height: 46)
        button.setTitle("자세히 보기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Labels
    
    private let genreTagLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(14)
        config.foregroundColor = .brand
        config.text = "어쿠스틱" // temp
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 8, vertical: 4)
        )
        label.backgroundColor = .xEEE7FB
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.lineBreakMode = .byTruncatingTail
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.text = "[여의도] Light ON 홀리데이 버스킹버스킹" // temp
        return LOLabel(config: config)
    }()
    
    private let dateLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "2025.05.01" // temp
        return LOLabel(config: config)
    }()
    
    private let timeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "17:00" // temp
        return LOLabel(config: config)
    }()
    
    private let placeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "서울 영등포구 여의도동 81-8" // temp
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addArrangedSubview(LOSpacer(18))
        contentView.addArrangedSubview(mainVStack)
        contentView.addArrangedSubview(LOSpacer(24))
        contentView.addArrangedSubview(showDetailHStack)
        contentView.addArrangedSubview(LOSpacer(24))
        
        mainVStack.addArrangedSubview(buttonsHStack)
        mainVStack.addArrangedSubview(LOSpacer(16))
        mainVStack.addArrangedSubview(genreTagHStack)
        mainVStack.addArrangedSubview(LOSpacer(12))
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(LOSpacer(12))
        mainVStack.addArrangedSubview(dateHStack)
        mainVStack.addArrangedSubview(LOSpacer(8))
        mainVStack.addArrangedSubview(placeHStack)
        
        buttonsHStack.addArrangedSubview(backButton)
        buttonsHStack.addArrangedSubview(LOSpacer())
        buttonsHStack.addArrangedSubview(shareButton)
        
        genreTagHStack.addArrangedSubview(genreTagLabel)
        genreTagHStack.addArrangedSubview(LOSpacer())
        
        dateHStack.insertArrangedSubview(dateLabel, at: 0)
        dateHStack.addArrangedSubview(timeLabel)
        dateHStack.addArrangedSubview(LOSpacer())
        
        placeHStack.addArrangedSubview(placeLabel)
        placeHStack.addArrangedSubview(LOSpacer())
        
        showDetailHStack.addArrangedSubview(showDetailButton)
    }
    
    // MARK: Public Configuration
    
    func configure(with info: GeoPerformanceInfo?) {
        guard let info else { return }
        genreTagLabel.config.text   = info.genre
        titleLabel.config.text      = info.title
        dateLabel.config.text       = info.date
        timeLabel.config.text       = info.time
        placeLabel.config.text      = info.location
    }
}

// MARK: - Preview

#Preview { MapSummaryModalView() }
