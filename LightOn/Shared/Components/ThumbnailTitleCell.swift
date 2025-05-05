//
//  ThumbnailTitleCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class ThumbnailTitleCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let id = "ThumbnailTitleCell"
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center, spacing: 14)
    private let thumbnailView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 130/2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .loBlack
        label.font = .pretendard.semiBold(16)
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if DEBUG
        titleLabel.text = "[여의도] Light ON 홀리데이 버스킹"
        thumbnailView.image = UIImage(named: "debug_busking")
        #endif
        
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(thumbnailView)
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        thumbnailView.snp.makeConstraints { $0.size.equalTo(130) }
    }
    
    // MARK: Configure
    
    func configure(item: any ThumbnailTitleCellItem) {
        thumbnailView.image = item.thumbnail
        titleLabel.text = item.title
    }
}

#Preview(traits: .fixedLayout(width: 130, height: 186)) { ThumbnailTitleCell() }
