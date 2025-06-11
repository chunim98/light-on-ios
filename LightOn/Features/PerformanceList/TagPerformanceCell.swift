//
//  TagPerformanceCell.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit

import SnapKit

final class TagPerformanceCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "TagPerformanceCell"
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center, spacing: 16)
    private let detailVStack = UIStackView(.vertical, alignment: .leading)
    
    private let thumbnailView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .background
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let typeLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(10)
        config.foregroundColor = .white
        config.lineHeight = 10
        config.text = "무료공연" // temp
        
        let label = TPPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 5, vertical: 3)
        )
        label.backgroundColor = .brand
        label.layer.maskedCorners = [.layerMaxXMaxYCorner]
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    private let tagLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(13)
        config.foregroundColor = .brand
        config.text = "#어쿠스틱" // temp
        return TPLabel(config: config)
    }()
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(15)
        config.foregroundColor = .loBlack
        config.text = "2025 여의도 물빛무대 눕콘" // temp
        return TPLabel(config: config)
    }()
    
    private let placeILContainer = {
        let container = TPIconLabelContainer()
        container.iconView.image = .performanceListPin
        
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .assistive
        config.text = "여의도동" // temp
        container.titleLabel.config = config
        
        let ellipse = Divider(width: 2, height: 2, color: .xD9D9D9)
        ellipse.layer.cornerRadius = 1
        
        container.addArrangedSubview(container.iconView)
        container.addArrangedSubview(Spacer(2))
        container.addArrangedSubview(container.titleLabel)
        container.addArrangedSubview(Spacer(4))
        container.addArrangedSubview(ellipse)
        container.addArrangedSubview(Spacer(4))
        return container
    }()
    
    private let dateLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .assistive
        config.text = "2025.05.01 17:00" // temp
        return TPLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaults()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { selectionStyle = .none }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        mainHStack.addArrangedSubview(thumbnailView)
        mainHStack.addArrangedSubview(detailVStack)
        
        thumbnailView.addSubview(typeLabel)
        
        detailVStack.addArrangedSubview(tagLabel)
        detailVStack.addArrangedSubview(Spacer(9))
        detailVStack.addArrangedSubview(titleLabel)
        detailVStack.addArrangedSubview(Spacer(6))
        detailVStack.addArrangedSubview(placeILContainer)
        
        placeILContainer.addArrangedSubview(dateLabel)
        
        mainHStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(12)
            $0.top.equalToSuperview()
        }
        thumbnailView.snp.makeConstraints { $0.size.equalTo(90) }
        typeLabel.snp.makeConstraints { $0.leading.top.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func configure(item: TagPerformanceCellItem?) {
        // item?.thumbnailPath 는 나중에 킹피셔 넣으면..?
        typeLabel.isHidden      = item?.typeLabelHidden ?? true
        tagLabel.config.text    = item?.tag
        titleLabel.config.text  = item?.title
        placeILContainer.titleLabel.config.text = item?.place
        dateLabel.config.text   = item?.date
    }
}

// MARK: - Preview

#Preview { TagPerformanceCell() }
