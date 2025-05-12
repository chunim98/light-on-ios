//
//  MediumEventCardCollectionCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

final class MediumEventCardCollectionCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let id = "MediumEventCardCollectionCell"
    
    // MARK: Components
    
    private let mediumEventCardView = MediumEventCardView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(mediumEventCardView)
        contentView.snp.makeConstraints { $0.center.equalToSuperview() }
        mediumEventCardView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configuration
    
    func configure(item: any MediumEventCardItem) {
        mediumEventCardView.configure(item: item)
    }
}

#Preview { MediumEventCardCollectionCell() }
