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
        let iv = UIImageView(image: .eventCardCellClock)
        iv.contentMode = .scaleAspectFit
        
        let sv = UIStackView()
        sv.alignment = .center
        sv.spacing = 5
        sv.addArrangedSubview(iv)
        return sv
    }()
    
    private let locationHStack = {
        let iv = UIImageView(image: .eventCardCellPin)
        iv.contentMode = .scaleAspectFit
        
        let sv = UIStackView()
        sv.alignment = .center
        sv.spacing = 6
        sv.addArrangedSubview(iv)
        return sv
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
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    private let dateLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    private let timeLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    private let locationLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
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
        detailsVStack.addArrangedSubview(LOSpacer(8))
        detailsVStack.addArrangedSubview(dateTimeHStack)
        detailsVStack.addArrangedSubview(LOSpacer(5))
        detailsVStack.addArrangedSubview(locationHStack)
        
        dateTimeHStack.addArrangedSubview(dateLabel)
        dateTimeHStack.addArrangedSubview(LODivider(
            width: 1, height: 10, color: .disable
        ))
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubview(LOSpacer())
        
        locationHStack.addArrangedSubview(locationLabel)
        locationHStack.addArrangedSubview(LOSpacer())
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(278)
            $0.height.equalTo(158)
        }
    }
    
    // MARK: Public Configuration

    func configure(item: LargeEventCardItem?) {
        thumbnailView.image = item?.thumbnail
        titleLabel.config.text = item?.title
        dateLabel.config.text = item?.date
        timeLabel.config.text = item?.time
        locationLabel.config.text = item?.location
    }
}

// MARK: - Preview

#Preview { LargeEventCardCell() }
#Preview { HomeVC() }
