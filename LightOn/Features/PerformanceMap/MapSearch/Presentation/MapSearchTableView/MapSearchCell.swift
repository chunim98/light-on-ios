//
//  MapSearchCell.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import UIKit

import SnapKit

final class MapSearchCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "MapSearchCell"
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center, spacing: 10)
    private let labelVStack = UIStackView(.vertical)
    
    private let pinImageView = {
        let iv = UIImageView(image: .mapPin)
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(20) }
        return iv
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.lineBreakMode = .byTruncatingTail
        config.font = .pretendard.medium(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 20
        return LOLabel(config: config)
    }()
    
    private let detailLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .clickable
        config.lineHeight = 20
        return LOLabel(config: config)
    }()
    
    private let separator = LODivider(height: 1, color: .background)
    
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
        contentView.addSubview(separator)
        
        mainHStack.addArrangedSubview(pinImageView)
        mainHStack.addArrangedSubview(labelVStack)
        
        labelVStack.addArrangedSubview(titleLabel)
        labelVStack.addArrangedSubview(detailLabel)
        
        mainHStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(77)
        }
        separator.snp.makeConstraints {
            $0.horizontalEdges.equalTo(mainHStack)
            $0.bottom.equalTo(contentView)
        }
    }
    
    // MARK: Public Configuration
    
    func configure(with item: MapSearchCellItem?) {
        titleLabel.config.text = item?.name
        detailLabel.config.text = item?.description
    }
}
