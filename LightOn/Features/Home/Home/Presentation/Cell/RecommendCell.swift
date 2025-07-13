//
//  RecommendCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class RecommendCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let id = "RecommendCell"
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center, spacing: 14)
    
    private let thumbnailView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 124/2
        iv.clipsToBounds = true
        iv.snp.makeConstraints { $0.size.equalTo(124) }
        return iv
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 21
        let label = LOLabel(config: config)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(thumbnailView)
        mainVStack.addArrangedSubview(titleLabel)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func configure(item: RecommendCellItem?) {
        thumbnailView.image = item?.thumbnail
        titleLabel.config.text = item?.title
    }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 130, height: 186)) { RecommendCell() }
