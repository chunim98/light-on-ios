//
//  RecommendedEventSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

import SnapKit

final class RecommendedEventSectionView: UIStackView {
    
    // MARK: Typealias
    
    typealias Item = TestSmallEventCardItem // temp
    
    // MARK: Components

    private let headerView = HomeSectionHeaderView()
    private let collectionView = RecommendedEventCollectionView<Item>()
    
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configuration
        axis = .vertical
        
        // Layout
        setupLayout()
        
        #if DEBUG
        collectionView.setSnapshot(items: TestSmallEventCardItem.mockItems)
        #endif
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        headerView.titleLabel.text = title
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout

    private func setupLayout() {
        addArrangedSubview(headerView)
        addArrangedSubview(collectionView)
        headerView.snp.makeConstraints { $0.height.equalTo(63) }
        collectionView.snp.makeConstraints { $0.height.equalTo(206) }
    }
    
    // MARK: Public Configuration

    func setHeaderText(_ text: String) {
        headerView.titleLabel.text = text
    }
}

// MARK: Binders & Publishers

extension RecommendedEventSectionView {
    func itemsBinder(_ items: [Item]) {
        collectionView.setSnapshot(items: items)
    }
}

// MARK: - Preview

#Preview { RecommendedEventSectionView() }
