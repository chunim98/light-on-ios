//
//  HashtagPerformanceCell.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit

import Kingfisher
import SnapKit

final class HashtagPerformanceCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "HashtagPerformanceCell"
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center, spacing: 16)
    private let detailVStack = UIStackView(.vertical, alignment: .leading)
    private let placeHStack = {
        let iv = UIImageView(image: .performanceListPin)
        iv.contentMode = .scaleAspectFit
        
        let sv = UIStackView()
        sv.alignment = .center
        sv.addArrangedSubview(iv)
        sv.addArrangedSubview(LOSpacer(2))
        return sv
    }()
    
    private let thumbnailView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .background
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let typeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(10)
        config.foregroundColor = .white
        config.lineHeight = 10
        
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 5, vertical: 3)
        )
        label.backgroundColor = .brand
        label.layer.maskedCorners = [.layerMaxXMaxYCorner]
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    private let hashtagLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(13)
        config.foregroundColor = .brand
        return LOLabel(config: config)
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(15)
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    private let placeLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .assistive
        return LOLabel(config: config)
    }()
    
    private let dateLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .assistive
        return LOLabel(config: config)
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
        
        detailVStack.addArrangedSubview(hashtagLabel)
        detailVStack.addArrangedSubview(LOSpacer(9))
        detailVStack.addArrangedSubview(titleLabel)
        detailVStack.addArrangedSubview(LOSpacer(6))
        detailVStack.addArrangedSubview(placeHStack)
        
        placeHStack.addArrangedSubview(placeLabel)
        placeHStack.addArrangedSubview(LOSpacer(4))
        placeHStack.addArrangedSubview({
            let ellipse = LODivider(width: 2, height: 2, color: .xD9D9D9)
            ellipse.layer.cornerRadius = 1
            return ellipse
        }())
        placeHStack.addArrangedSubview(LOSpacer(4))
        placeHStack.addArrangedSubview(dateLabel)
        
        mainHStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(12)
            $0.top.equalToSuperview()
        }
        thumbnailView.snp.makeConstraints { $0.size.equalTo(90) }
        typeLabel.snp.makeConstraints { $0.leading.top.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func configure(item: HashtagPerformanceCellItem?) {
        let thumbnailURL = URL(string: item?.thumbnailPath ?? "")
        thumbnailView.kf.indicatorType = .activity
        thumbnailView.kf.setImage(with: thumbnailURL)
        
        typeLabel.isHidden = item?.typeLabelHidden ?? true
        hashtagLabel.config.text = "#" + (item?.hashtag ?? "")
        titleLabel.config.text = item?.title
        placeLabel.config.text = item?.place
        dateLabel.config.text = item?.date
    }
}

// MARK: - Preview

#Preview { HashtagPerformanceCell() }
