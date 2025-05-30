//
//  LargeEventCardCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

final class LargeEventCardCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let id = "LargeEventCardCell"
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, spacing: 14)
    private let detailsVStack = UIStackView(.vertical, inset: .init(horizontal: 2))
    private let dateTimeHStack = {
        let il = TPIconLabelContainer()
        il.iconView.image = .eventCardCellClock
        il.addArrangedSubview(il.iconView)
        il.spacing = 5
        return il
    }()
    
    private let thumbnailView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .xD9D9D9
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(14)
        config.foregroundColor = .blackLO
        return TPLabel(config: config)
    }()
    
    private let dateLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return TPLabel(config: config)
    }()
    
    private let timeLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return TPLabel(config: config)
    }()
    
    private let locationIconLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        
        let il = TPIconLabelContainer()
        il.iconView.image = .eventCardCellPin
        il.titleLabel.config = config
        il.spacing = 6
        
        il.addArrangedSubview(il.iconView)
        il.addArrangedSubview(il.titleLabel)
        return il
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(thumbnailView)
        mainVStack.addArrangedSubview(detailsVStack)
        
        detailsVStack.addArrangedSubview(titleLabel)
        detailsVStack.addArrangedSubview(Spacer(8))
        detailsVStack.addArrangedSubview(dateTimeHStack)
        detailsVStack.addArrangedSubview(Spacer(5))
        detailsVStack.addArrangedSubview(locationIconLabel)
        
        dateTimeHStack.addArrangedSubview(dateLabel)
        dateTimeHStack.addArrangedSubview(Divider(width: 1, height: 10, color: .disable))
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubview(Spacer())
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(278)
            $0.height.equalTo(158)
        }
    }
    
    // MARK: Public Configuration

    func configure(item: (any LargeEventCardItem)?) {
        thumbnailView.image     = item?.thumbnail
        titleLabel.config.text  = item?.title
        dateLabel.config.text   = item?.date
        timeLabel.config.text   = item?.time
        locationIconLabel.titleLabel.config.text = item?.location
    }
}

// MARK: - Preview

#Preview { LargeEventCardCell() }
#Preview { HomeVC() }
