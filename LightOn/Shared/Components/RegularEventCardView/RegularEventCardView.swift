//
//  RegularEventCardView.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class RegularEventCardView: UIView {
    
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
    private let dateTimeHStack = UIStackView(spacing: 5)
    
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
    
    private let dateIconLabel = {
        let iconLabel = LOIconAttachedLabel()
        iconLabel.icon = UIImage(resource: .eventCardCellClock)
        iconLabel.font = .pretendard.regular(12)
        iconLabel.setColor(.caption)
        iconLabel.spacing = 5
        return iconLabel
    }()
    
    private let dateTimeDivider = LODivider(axis: .vertical, width: 1, color: .disable)
    
    private let timeLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(12)
        label.textColor = .caption
        return label
    }()
    
    private let placeIconLabel = {
        let iconLabel = LOIconAttachedLabel()
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
        dateIconLabel.text = "2025.05.01"
        timeLabel.text = "17:00"
        placeIconLabel.text = "서울 영등포구 여의도동 81-8"
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
        dateTimePlaceVStack.addArrangedSubview(placeIconLabel)
        // depth 4
        titleGenreHStack.addArrangedSubview(titleLabel)
        dateTimeHStack.addArrangedSubview(dateIconLabel)
        dateTimeHStack.addArrangedSubview(dateTimeDivider)
        dateTimeHStack.addArrangedSubview(timeLabel)
        dateTimeHStack.addArrangedSubview(UIView())
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints { $0.size.equalTo(80) }
        dateTimeHStack.snp.makeConstraints { $0.height.equalTo(14) }
        placeIconLabel.snp.makeConstraints { $0.height.equalTo(14) }
    }
}

#Preview { RegularEventCardView() }
