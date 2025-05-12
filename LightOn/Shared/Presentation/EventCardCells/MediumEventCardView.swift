//
//  MediumEventCardView.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class MediumEventCardView: UIView {
    
    // MARK: Components
    
    // Containers
    private let mainHStack = {
        let sv = UIStackView(alignment: .center, spacing: 12)
        sv.clipsToBounds = true
        sv.layer.borderWidth = 1
        sv.layer.cornerRadius = 5
        sv.inset = .init(edges: 12)
        sv.layer.borderColor = UIColor.disable.cgColor
        return sv
    }()
    private let detailVStack = UIStackView(.vertical, spacing: 8)
    private let artistTitleGenreVStack = UIStackView(.vertical, spacing: 5)
    private let dateTimePlaceVStack = UIStackView(.vertical, spacing: 5)
    private let titleGenreHStack = UIStackView(spacing: 4)
    private let dateTimeHStack = LODividerStackView(spacing: 5)
    
    // Components
    private let thumbnailView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let artistLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(12)
        label.textColor = .caption
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(12)
        label.textColor = .loBlack
        return label
    }()
    
    private let genreTagView = LOGenreTagView()
    
    private let dateIconLabel = {
        let iconLabel = LOIconLabel()
        iconLabel.icon = UIImage(resource: .eventCardCellClock)
        iconLabel.font = .pretendard.regular(12)
        iconLabel.setColor(.caption)
        iconLabel.spacing = 5
        return iconLabel
    }()
        
    private let timeLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(12)
        label.textColor = .caption
        return label
    }()
    
    private let locationIconLabel = {
        let iconLabel = LOIconLabel()
        iconLabel.icon = UIImage(resource: .eventCardCellPin)
        iconLabel.font = .pretendard.regular(12)
        iconLabel.setColor(.caption)
        iconLabel.spacing = 6
        return iconLabel
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if DEBUG
        thumbnailView.image = UIImage(resource: .debugBusking)
        artistLabel.text = "라이트온"
        titleLabel.text = "[여의도] Light ON 홀리데이 버스킹"
        genreTagView.text = "어쿠스틱"
        dateIconLabel.text = "2025.05.01"
        timeLabel.text = "17:00"
        locationIconLabel.text = "서울 영등포구 여의도동 81-8"
        #endif
        
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        // depth 0
        self.addSubview(mainHStack)
        // depth 1
        mainHStack.addArrangedSubview(thumbnailView)
        mainHStack.addArrangedSubview(detailVStack)
        // depth 2
        detailVStack.addArrangedSubview(artistTitleGenreVStack)
        detailVStack.addArrangedSubview(dateTimePlaceVStack)
        // depth 3
        artistTitleGenreVStack.addArrangedSubview(artistLabel)
        artistTitleGenreVStack.addArrangedSubview(titleGenreHStack)
        dateTimePlaceVStack.addArrangedSubview(dateTimeHStack)
        dateTimePlaceVStack.addArrangedSubview(locationIconLabel)
        // depth 4
        titleGenreHStack.addArrangedSubview(titleLabel)
        titleGenreHStack.addArrangedSubview(genreTagView)
        titleGenreHStack.addArrangedSubview(UIView())
        dateTimeHStack.addArrangedSubview(dateIconLabel)
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubviewWithoutDivider(UIView())
        
        genreTagView.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints { $0.size.equalTo(80) }
        dateTimeHStack.snp.makeConstraints { $0.height.equalTo(14) }
        locationIconLabel.snp.makeConstraints { $0.height.equalTo(14) }
    }
    
    // MARK: Configuration
    
    private func configure(item: any MediumEventCardItem) {
        thumbnailView.image = item.thumbnail
        artistLabel.text = item.artist
        titleLabel.text = item.title
        genreTagView.text = item.genre
        dateIconLabel.text = item.date
        timeLabel.text = item.time
        locationIconLabel.text = item.location
    }
}

#Preview { MediumEventCardView() }
