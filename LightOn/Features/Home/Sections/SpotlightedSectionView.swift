//
//  SpotlightedSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

import SnapKit

final class SpotlightedSectionView: BaseHomeSectionView {
    
    // MARK: Components
    
    private let collectionView = SpotlightedSectionCollectionView()
    
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
        collectionView.setSnapshot(items: MediumEventCardItem.mockItems) // temp
        titleLabel.config.text = "주목할 만한 아티스트 공연"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { $0.height.equalTo(120) }
    }
}

// MARK: Binders & Publishers

extension SpotlightedSectionView {
    func itemsBinder(_ items: [MediumEventCardItem]) {
        collectionView.setSnapshot(items: items)
    }
}

// MARK: - Preview

#Preview { SpotlightedSectionView() }

