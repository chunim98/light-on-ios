//
//  PopularSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

import SnapKit

final class PopularSectionView: BaseHomeSectionView {
        
    // MARK: Components

    private let collectionView = PopularSectionCollectionView()
    
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
        titleLabel.config.text = "현재 인기 있는 공연"
        collectionView.setSnapshot(items: LargeEventCardItem.mockItems) // temp
    }
    
    // MARK: Layout

    private func setupLayout() {
        addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { $0.height.equalTo(246.17) }
    }
}

// MARK: Binders & Publishers

extension PopularSectionView {
    func itemsBinder(_ items: [LargeEventCardItem]) {
        collectionView.setSnapshot(items: items)
    }
}

// MARK: - Preview

#Preview { PopularSectionView() }
