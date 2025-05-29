//
//  MediumEventCardView.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class MediumEventCardView: UIStackView {
    
    // MARK: Components
    
    private let detailVStack = UIStackView(.vertical)
    private let titleGenreHStack = UIStackView(spacing: 4)
    private let dateTimeHStack = {
        let il = TPIconLabelStack()
        il.iconView.image = .eventCardCellClock
        il.addArrangedSubview(il.iconView)
        il.spacing = 5
        return il
    }()

    private let thumbnailView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let artistLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        return TPLabel(config: config)
    }()
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(12)
        config.foregroundColor = .blackLO
        return TPLabel(config: config)
    }()
    
    private let genreLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(8)
        config.foregroundColor = .brand
        
        let padding = UIEdgeInsets(horizontal: 4, vertical: 2)
        let label = TPPaddingLabel(configuration: config, padding: padding)
        label.backgroundColor = .xF5F0FF
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
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
        
        let il = TPIconLabelStack()
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
        detailVStack.addArrangedSubview(Spacer(spacing: 5))
        detailVStack.addArrangedSubview(titleGenreHStack)
        detailVStack.addArrangedSubview(Spacer(spacing: 8))
        detailVStack.addArrangedSubview(dateTimeHStack)
        detailVStack.addArrangedSubview(Spacer(spacing: 5))
        detailVStack.addArrangedSubview(locationIconLabel)

        titleGenreHStack.addArrangedSubview(titleLabel)
        titleGenreHStack.addArrangedSubview(genreLabel)
        titleGenreHStack.addArrangedSubview(Spacer())
        
        dateTimeHStack.addArrangedSubview(dateLabel)
        dateTimeHStack.addArrangedSubview(Divider(width: 1, height: 10, color: .disable))
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubview(Spacer())
        
        genreLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        thumbnailView.snp.makeConstraints { $0.size.equalTo(80) }
    }
    
    // MARK: Public Configuration

    func configure(item: (any MediumEventCardItem)?) {
        thumbnailView.image     = item?.thumbnail
        artistLabel.config.text = item?.artist
        titleLabel.config.text  = item?.title
        genreLabel.config.text  = item?.genre
        dateLabel.config.text   = item?.date
        timeLabel.config.text   = item?.time
        locationIconLabel.titleLabel.config.text = item?.location
    }
}

// MARK: - Preview

#Preview { MediumEventCardView() }
#Preview { HomeVC() }
