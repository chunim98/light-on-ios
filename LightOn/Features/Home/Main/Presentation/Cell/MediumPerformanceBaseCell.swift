//
//  MediumPerformanceBaseCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import Kingfisher
import SnapKit

final class MediumPerformanceBaseCell: UIStackView {
    
    // MARK: Components
    
    private let detailVStack = UIStackView(.vertical)
    private let titleGenreHStack = UIStackView(spacing: 4)
    
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let artistLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return LOLabel(config: config)
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(12)
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    private let genreLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(8)
        config.foregroundColor = .brand
        
        let padding = UIEdgeInsets(horizontal: 4, vertical: 2)
        let label = LOPaddingLabel(configuration: config, padding: padding)
        label.backgroundColor = .xF5F0FF
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
    
    private let locationLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
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
        layer.borderColor = UIColor.disable.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        clipsToBounds = true
        inset = .init(edges: 12)
        alignment = .center
        spacing = 12
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(thumbnailView)
        addArrangedSubview(detailVStack)

        detailVStack.addArrangedSubview(artistLabel)
        detailVStack.addArrangedSubview(LOSpacer(5))
        detailVStack.addArrangedSubview(titleGenreHStack)
        detailVStack.addArrangedSubview(LOSpacer(8))
        detailVStack.addArrangedSubview(dateTimeHStack)
        detailVStack.addArrangedSubview(LOSpacer(5))
        detailVStack.addArrangedSubview(locationHStack)

        titleGenreHStack.addArrangedSubview(titleLabel)
        titleGenreHStack.addArrangedSubview(genreLabel)
        titleGenreHStack.addArrangedSubview(LOSpacer())
        
        dateTimeHStack.addArrangedSubview(dateLabel)
        dateTimeHStack.addArrangedSubview(LODivider(
            width: 1, height: 10, color: .disable
        ))
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubview(LOSpacer())
        
        locationHStack.addArrangedSubview(locationLabel)
        locationHStack.addArrangedSubview(LOSpacer())
        
        genreLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        thumbnailView.snp.makeConstraints { $0.size.equalTo(80) }
    }
    
    // MARK: Public Configuration

    func configure(item: MediumPerformanceCellItem?) {
        let thumbnailURL = URL(string: item?.thumbnailPath ?? "")
        thumbnailView.kf.indicatorType = .activity
        thumbnailView.kf.setImage(with: thumbnailURL)

        artistLabel.config.text = item?.artist
        titleLabel.config.text = item?.title
        genreLabel.config.text = item?.genre
        dateLabel.config.text = item?.date
        timeLabel.config.text = item?.time
        locationLabel.config.text = item?.location
    }
}

// MARK: - Preview

#Preview { MediumPerformanceBaseCell() }
#Preview { HomeVC() }
