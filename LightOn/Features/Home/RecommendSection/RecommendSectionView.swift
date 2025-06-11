//
//  RecommendSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

import SnapKit

final class RecommendSectionView: BaseHomeSectionView {
    
    // MARK: Components

    private let collectionView = RecommendSectionCollectionView()
    
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
        titleLabel.config.text = "추천 공연"
        collectionView.setSnapshot(items: SmallEventCardItem.mockItems) // temp
    }
    
    // MARK: Layout

    private func setupLayout() {
        addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { $0.height.equalTo(206) }
    }
}

// MARK: Binders & Publishers

extension RecommendSectionView {
    func itemsBinder(_ items: [SmallEventCardItem]) {
        collectionView.setSnapshot(items: items)
    }
}

// MARK: - Preview

#Preview { RecommendSectionView() }
