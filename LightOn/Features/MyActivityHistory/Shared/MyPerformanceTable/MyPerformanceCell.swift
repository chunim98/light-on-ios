//
//  MyPerformanceCell.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//

import UIKit

import SnapKit

final class MyPerformanceCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "MyPerformanceCell"
    
    // MARK: Containers
    
    private let mainHStack = {
        let arrowImageView = UIImageView()
        arrowImageView.image = .activityHistoryArrowRight
        arrowImageView.contentMode = .scaleAspectFit
        
        let sv = UIStackView()
        sv.inset = .init(edges: 16)
        sv.layer.cornerRadius = 5
        sv.clipsToBounds = true
        sv.alignment = .center
        sv.spacing = 12
        
        sv.addArrangedSubview(LOSpacer())
        sv.addArrangedSubview(arrowImageView)
        return sv
    }()
    
    private let contentVStack = UIStackView(.vertical)
    
    private let titleHStack = UIStackView()
    
    private let dateTimeHStack = {
        let clockImageView = UIImageView()
        clockImageView.image = .activityHistoryClock
        clockImageView.contentMode = .scaleAspectFit
        
        let pinImageView = UIImageView()
        pinImageView.image = .activityHistoryPin
        pinImageView.contentMode = .scaleAspectFit
        
        let sv = UIStackView()
        sv.alignment = .center
        
        sv.addArrangedSubview(clockImageView)
        sv.addArrangedSubview(LOSpacer(5))
        sv.addArrangedSubview(LOSpacer(5))
        sv.addArrangedSubview(
            LODivider(width: 1, height: 10, color: .disable)
        )
        sv.addArrangedSubview(LOSpacer(5))
        sv.addArrangedSubview(LOSpacer(12))
        sv.addArrangedSubview(pinImageView)
        sv.addArrangedSubview(LOSpacer(5))
        return sv
    }()
    
    // MARK: Labels
    
    private let statusLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(12)
        return LOLabel(config: config)
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(12)
        config.foregroundColor = .black
        return LOLabel(config: config)
    }()
    
    private let typeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(8)
        config.foregroundColor = .brand
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 4, vertical: 2)
        )
        label.backgroundColor = .white
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let dateLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    private let timeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    private let placeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    
    private let publishedLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .clickable
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { selectionStyle = .none }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        mainHStack.insertArrangedSubview(contentVStack, at: 0)
        
        contentVStack.addArrangedSubview(statusLabel)
        contentVStack.addArrangedSubview(LOSpacer(5))
        contentVStack.addArrangedSubview(titleHStack)
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(dateTimeHStack)
        contentVStack.addArrangedSubview(LOSpacer(6))
        contentVStack.addArrangedSubview(publishedLabel)
        
        titleHStack.addArrangedSubview(titleLabel)
        titleHStack.addArrangedSubview(LOSpacer(4))
        titleHStack.addArrangedSubview(typeLabel)
        titleHStack.addArrangedSubview(LOSpacer())
        
        dateTimeHStack.insertArrangedSubview(dateLabel, at: 2)
        dateTimeHStack.insertArrangedSubview(timeLabel, at: 6)
        dateTimeHStack.insertArrangedSubview(placeLabel, at: 10)
        dateTimeHStack.addArrangedSubview(LOSpacer())
        
        mainHStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
        }
    }
    
    // MARK: Public Configuration
    
    func configure(with item: MyPerformanceCellItem?) {
        // Value
        titleLabel.config.text      = item?.title
        typeLabel.config.text       = item?.type
        dateLabel.config.text       = item?.date
        timeLabel.config.text       = item?.time
        placeLabel.config.text      = item?.place
        publishedLabel.config.text  = item?.publishedAt
        // Style
        statusLabel.config.text             = item?.style.statusText
        statusLabel.config.foregroundColor  = item?.style.statusForegroundColor
        mainHStack.backgroundColor          = item?.style.backgroundColor
    }
}

// MARK: - Preview

#Preview { MyPerformanceCell() }
