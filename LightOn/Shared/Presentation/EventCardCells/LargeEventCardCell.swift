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
    private let detailsVStack = UIStackView(.vertical, spacing: 8, inset: .init(horizontal: 2))
    private let scheduleVStack = UIStackView(.vertical, spacing: 5)
    private let dateTimeHStack = LODividerStackView(spacing: 5)

    private let thumbnailView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(hex: 0xD9D9D9)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.bold(14)
        label.textColor = .loBlack
        return label
    }()
    
    private let dateIconLabel = {
        let il = LOIconLabel()
        il.icon = UIImage(resource: .eventCardCellClock)
        il.font = .pretendard.regular(12)
        il.setColor(.caption)
        il.spacing = 5
        return il
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(12)
        label.textColor = .caption
        return label
    }()
    
    private let locationIconLabel = {
        let il = LOIconLabel()
        il.icon = UIImage(resource: .eventCardCellPin)
        il.font = .pretendard.regular(12)
        il.setColor(.caption)
        il.spacing = 6
        return il
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if DEBUG
        thumbnailView.image = UIImage(resource: .debugBusking)
        titleLabel.text = "[여의도] Light ON 홀리데이 버스킹"
        locationIconLabel.text = "서울 영등포구 여의도동 81-8"
        dateIconLabel.text = "2025.05.01"
        timeLabel.text = "17:00"
        #endif
        
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(mainVStack)
        // depth 1
        mainVStack.addArrangedSubview(thumbnailView)
        mainVStack.addArrangedSubview(detailsVStack)
        // depth 2
        detailsVStack.addArrangedSubview(titleLabel)
        detailsVStack.addArrangedSubview(scheduleVStack)
        // depth 3
        scheduleVStack.addArrangedSubview(dateTimeHStack)
        scheduleVStack.addArrangedSubview(locationIconLabel)
        // depth 4
        dateTimeHStack.addArrangedSubview(dateIconLabel)
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubviewWithoutDivider(UIView())

        contentView.snp.makeConstraints { $0.center.equalToSuperview()}
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(278)
            $0.height.equalTo(158)
        }
        dateTimeHStack.snp.makeConstraints { $0.height.equalTo(14) }
        locationIconLabel.snp.makeConstraints { $0.height.equalTo(14) }
    }
    
    // MARK: Configuration
    
    func configure(item: any LargeEventCardItem) {
        thumbnailView.image    = item.thumbnail
        titleLabel.text        = item.title
        dateIconLabel.text     = item.date
        timeLabel.text         = item.time
        locationIconLabel.text = item.location
    }
}

#Preview { LargeEventCardCell() }
